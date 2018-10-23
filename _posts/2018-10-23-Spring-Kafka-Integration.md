---
layout: post
title: Spring with Kafak
comments: true
---
# 스프링 카프카 연동하기

이번 아티클에서는 스프링과 카프카를 연동하여 요청 메시지를 카프카로 전달하고, 전달된 카프카 메시지를 수신받아서 로깅을 남긴후, 다시 완료처리되었다고 카프카로 메시지를 전송하는 모듈을 만들어 볼 것이다. 

## Kafka 설치하기 

카프카 설치하기는 다음 [Kafka Quickstart](https://kafka.apache.org/quickstart) 에 아주 잘 나타니있다. 

우선 테스트틑 MAC OS 에서 수행하는 것을 가정하고 작업하도록 하겠다. 

Kafka download : [Download](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.0.0/kafka_2.11-2.0.0.tgz) 에서 최신버젼을 다운받자 <br/>
환경설정하기 : <br/>
```vi
> vi .bash_profile
```

```vi
export KAFKA_HOME=/Users/kidobae/Documents/00.TOOLS/kafka_2.11-2.0.0
export PATH=$KAFKA_HOME:$PATH
```

```vi
> source .bash_profile
```

Kafka 실행하기<br/>
Kafka 실행을 위해서는 우선 주키퍼부터 실행한다. 주키퍼는 카프카 클러스터를 구성할때, 각 클러스터의 상태를 관리하고, 하나의 클러스터로 동작할 수 있도록 관리해준다.<br/>

```vi
> cd /Users/kidobae/Documents/00.TOOLS/kafka_2.11-2.0.0
> bin/zookeeper-server-start.sh config/zookeeper.properties
2013-04-22 15:01:37,495] INFO Reading configuration from: config/zookeeper.properties (org.apache.zookeeper.server.quorum.QuorumPeerConfig)
...
``` 
Kafka 서버 실행하기 
```vi
> bin/kafka-server-start.sh config/server.properties
[2013-04-22 15:01:47,028] INFO Verifying properties (kafka.utils.VerifiableProperties)
[2013-04-22 15:01:47,051] INFO Property socket.send.buffer.bytes is overridden to 1048576 (kafka.utils.VerifiableProperties)
...
```

* Topic 생성하기

Kafka 에서는 토픽을 통해서 메시지를 전달한다. Topic 은 메시지를 특정 토픽 네임으로 전달하게 되면, 해당 토픽을 컨슈밍 하는 시스템에서 메시지를 수신할 수있는 통로로 생각하면 된다. 
```vi
> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic reception-user
> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic result-reception
```
--create : 토픽을 생성하겠다는 의미이다.<br/>
--zookeeper <ip:port> : 카프카를 관리하는 주키퍼의 IP/Port를 지정한다.<br/> 
--replication-factor : 메시지가 들어오면 복제를 몇개할지 지정하며 보통 홀수개를 지정한다. 여기서는 1로 복제를 하지 않겠다는 의미이다.<br/>
--partitions : 토픽은 여러개의 파티션으로 구성된다. 파티션은 메시지가 들어오면 지정된 파티션으로 전달이 되고, 컨슈머는 지정된 파티션에서 원하는 메시지를 가져갈 수 있다.<br/>
파티션을 여러개 지정하면 순서보장은 안되지만, 매우 빠른속도로 대용량 메시지 전송이 가능하다. <br/>
--topic : 실제 토픽 이름을 지정한다. (우리는 이 이름을 프로그램에서 이용할 것이다.)<br/>


다음 명령어로 토픽의 목록을 살펴 볼 수 있다. 
```vi
> bin/kafka-topics.sh --list --zookeeper localhost:2181
```
 
## 시나리오 작성하기

사용자는 접수처에 자신의 정보를 입력하고, 접수 반호를 받는다. <br/>
접수후 업무 처리 부서에서는 해당 업무를 처리하고, 처리 결과를 카프카로 전송한다. <br/>
고객은 자신의 접수번호를 가지고, 완료되었는지 몇차례 물어본다.<br/>

위 작업을 위해서 우선 우리는 2개의 REST API를 다음과 같이 만들 것이다.

#### API 목록 
* 유저정보 저장 : <br/>
|POST|/reception/user-info|{"name":"XXX", "age":20, "height":180, "weight":77}|{"receiptId":111}|<br/>
비동기로 처리되며 접수번호를 발급하고, 바로 Kafka "reception-user" 토픽으로 메시지를 전송한다. <br/>
메시지 처리가 완료되면 완료 되었음을 알리기 위해서 Kafka "result-reception" 토픽으로 메시지를 전송한다.<br/>

* 유저정보 조회 : <br/>
|GET|/reception/{receiptId}|empty|{"status":"COMPLETE", "userInfo":{"name":"XXX", "age":20, "height":180, "weight":77}}|<br/>
동기로 처리되며, 유저 정보를 반환한다. 이때 receiptId 를 이용하여 로컬 메모리에 저장된 사용자 정보를 조회하며, 해당 데이터 상태를 조회한다.<br/>

#### 처리상태 정의 
|RECEIPTED|접수(큐로메시지전송시)|<br/>
|PROCESSING|처리중|<br/>
|COMPLETE|처리완료|<br/>
|ERROR|처리중에러발생|<br/>

## 스프링 프로젝트 생성하기

프로젝트를 다음과 정과 같이 생성한다. 

![create project](/img/201810/spring-kafak/spring-kafka01.png)

![select dependency](/img/201810/spring-kafak/spring-kafka02.png)


{% if page.comments %}
<div id="disqus_thread"></div>
<script>
   /**
     *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
     *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
     */
    /*
    var disqus_config = function () {
        this.page.url = PAGE_URL;  // Replace PAGE_URL with your page's canonical URL variable
        this.page.identifier = PAGE_IDENTIFIER; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };
    */
    (function() {  // DON'T EDIT BELOW THIS LINE
        var d = document;
        s = d.createElement('script'); 
        s.src = '//https-unclebae-github-io.disqus.com/embed.js';
        
        s.setAttribute('data-timestamp', +new Date());
        (d.head || d.body).appendChild(s);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
{% endif %}


