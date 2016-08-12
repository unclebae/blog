---
layout: post
title: Tomcat JDBC Connection Pool 소개
comments: true
---

## 소개 
```org.apache.tomcat.jdbc.pool```은 Apache Commons DBCP커텍션 풀의 대용으로 사용된다. 

### 사용이유

1. Common DBCP 1.x 버젼은 단일 쓰레드로 동작한다. 전체 풀의 공통적인 lock에 대해서 thread safe 한 처리를 위해서 사용되며, Common DBCP 2.x에서는 달라졌다. 
2. Common DBCP 1.x 는 느리다. 논리적인 CPU의 증가와 현재 concurrent threads가 풀을 빌려오고, 반환하는 량이 증가하는 경우 성능상 많은 문제가 발생한다. 높은 병렬처리 시스템에서는 이는 문제가 될 수 있다. Common DBCP 2.x버젼에서는 달라졌다. 
3. Common DBCP는 60개 이상의 클래스를 가진다. tomcat-jdbc-pool은 8개의 클래스로 동작한다. 그러므로 기능의 변화를 위해서 작은 수정으로도 가능하다. 
4. Common DBCP는 정적 인터페이스를 이용한다. 이 의미는 JRE의 올바른 버젼을 사용해야한다는 말이다. 그렇지 않으면 NoSuchMethodException 보게 될 것이다. 
5. 60개의 클래스를 사용하지 않고서도 충분히 간단한 구현을 할 수 있다. 
6. Tomcat jdbc pool은 비동기적으로 커넥션을 탐색할 수 있다. 이를 위해 추가적으로 스레드를 사용할 필요가 없다. 
7. Tomcat jdbc pool은 톰캣 모듈이다. 이것은 Tomcat JULI에 의존하며, 톰캣 내에 사용된 로깅 프레임워크를 이용한다. 
8. javax.sql.PooledConnection인터페이스를 통해서 커넥션을 가져올 수 있다. 
9. 풀 고갈에 대한 starvation을 막기 위해서 pool이 비어있는경우 스레드는 커넥션을 기다린다. 커넥션이 반환되면 올바르게 스레드 대기중인 객체를 깨우게 된다. 대부분의 풀은 단순히 starve된다.

### 추가 된 기능들

1. 높은 병렬처리 환경이나 멀티코어/cpu시스템에서 사용이 가능하다. 
2. 동적 인터페이스의 구현을 수행한다. 이는 java.sql과 javax.sql인터페이스를 제공하며, 비록 낮은 버젼의 JDK 에서도 컴파일이 가능하다. 
3. 검증 인터벌 - 커넥션을 사용하기 위해서 매번 validate하지 않아도 된다. 단지 커넥션을 빌리고 반환하면 된다.
4. Run-Once쿼리 설정가능한 쿼리는 한번만 실행이 된다. 이는 커넥션이 데이터베이스와 상호 연결을 할때 수행이 되며 이는 세션 설정시 매우 유용하다 그리고 원하는경우 전체 시간에 걸쳐서 커넥션이 설정된 상태로 남는다.
5. 커스텀 인터셉터 설정이 가능하며, 인터셉터를 이용하여 쿼리 상태를 수집하고, 세션 상태를 캐시하며, 실패한 커넥션을 다시 접속하도록 한다. 또한 쿼리를 재시도 하며, 쿼리 결과를 캐시하는 등의 작업을 한다. 
6. 고성능 : 이후에 서로다른 성능관련 내역을 보여줄 것이다. 
7. 매우 단순하며, 단순한 구현으로 만들어졌다. 소스 파일이나 길이는 c3po에 비해서 매우 짧으며, 버그도 매우 적다. 단지 8개의 클래스로 구성되며, 커넥션 풀은 그 절반정도 된다. 버그가 발견이되면, 매우 빠르게 찾아낼 수 있으며 쉽게 수정이 가능하다.  
8. 비동기 커넥션 획득 : 커넥션을 위해 큐에 요청을 할 수 있으며, Future<Connection>을 통해서 수신 받는다. 
9. 더 쉽게 idle 커넥션을 컨트롤 할 수 있으며, 이는 커넥션을 직접 접근하는 것대신에 초기 풀의 개수와 idle풀의 개수를 지정할 수 있다. 
10. 어느 시점에 커넥션이 버려질지 결정할 수 있다. 풀이 꽉 찻을때, 그리고 idle풀의 크기등에 대해서 스마트 알고리즘증으로 수행가능하다. 
11. 커넥션ㅇ르 버리는 타이머는 statement/query 액티비티에 동작한다. 
12. 특정타임동안 커넥션을 사용하고 커넥션을 닫는다. 
13. JMX노티를 얻는것과 커넥션이 서스펙트 되어고 버려지게 되는 경우에 rev
14. 커넥션은 java.sql.Driver, javax.sql.DataSource, javax.sql.XADataSource 이는 dataSource, dataSourceJNDI 속성으로 이용이 가능하다. 
15. XA커넥션을 제공한다. 

계속...

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

