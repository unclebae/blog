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

Topic 생성하기

Kafka 에서는 토픽을 통해서 메시지를 전달한다. Topic 은 메시지를 특정 토픽 네임으로 전달하게 되면, 해당 토픽을 컨슈밍 하는 시스템에서 메시지를 수신할 수있는 통로로 생각하면 된다. 
```vi
> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic reception-user
> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic result-reception
> bin/kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 5 --topic partition
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

### pom.xml 둘러보기
```xml

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.kafka</groupId>
            <artifactId>spring-kafka</artifactId>
        </dependency>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
```

우리는 KafkaTemplate 과, KafkaXXXFactory를 생성하기 위해서 spring-kafka 의존성을 추가해준 것을 확인할 수 있다. 

### application.properties 설정하기. 

SpringBoot 에서는 application.properties 파일을 이용하여 설정파일을 지정한다. 

```properties
# 카프카 주소 
kafka.address=localhost:9092

# 접수 토픽명 
receipt.topic.name=reception-user
# 결과반환 토픽명 
result.topic.name=result-reception
# 파티션된 토픽명 (로깅을 위해서 사용)
partition.topic.name=partition
# 파티션 카운트 
partition.count=5
```

### 전달 메시지 객체 생성하기 

* 우리는 2가지 메시지 객체를 생성할 것이다. <br/>
UserInfo : 사용자로 부터 입력되는 메시지 객체로 (이름, 나이, 키, 몸무게) 를 저장한다. <br/>
ReceiptInfo : 카프카로 전달되는 메시지객체로 UserInfo 감싸고, 상태값을 저장한다. 

* 상태 객체 <br/>
ReceiptCode : 접수상태를 나타내는 코드이다. 위 상태정의대로 정의하였다. 

UserInfo.java
```java
package com.example.spring.kafka.springkafka.message;

import lombok.*;

@Setter
@Getter
@ToString
@NoArgsConstructor
public class UserInfo {
    private String name;
    private Integer age;
    private Float height;
    private Float weight;
}

```

ReceiptInfo.java
```java
package com.example.spring.kafka.springkafka.message;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ReceiptInfo {

    /**
     * 접수번호
     */
    private Long receiptId;

    /**
     * 접수상태코드
     */
    private ReceiptCode receiptCode;

    /**
     * 접수정보
     */
    private UserInfo userInfo;

    public ReceiptInfo(){};

    public ReceiptInfo(Long receiptId, ReceiptCode receiptCode, UserInfo userInfo) {
        this.receiptId = receiptId;
        this.receiptCode = receiptCode;
        this.userInfo = userInfo;
    }
}
```

ReceiptCode.java
```java
package com.example.spring.kafka.springkafka.message;

import lombok.Getter;

@Getter
public enum ReceiptCode {

    RECEIPTED,
    PROCESSING,
    COMPLETED,
    FAILED

}

```

### 카프카 ProducerConfig 생성하기 

ProducerConfig 는 카프카와 스프링을 연동하기 위한 빈들을 정의하는 객체이다.<br/> 
여기서는 연동시에 Serialize/Deserialize 방식을 지정한다. <br/>
우리는 2가지 Producer 를 생성할 것이며, 하나는 스트링방식, 다른하나는 커스텀 객체 메시지를 패싱할 수 있는 방식을 지정한다. 

Factory는 카프카 Producer 를 생성하기 위한 팩토리 이다. <br/>
KafkaTemplate 는 Kafka와 통신할 api를 가지고 있는 객체로, 매우 편라히게 Kafka와 통신을 할 수 있다. 

KafkaProducerConfig.java
```java
package com.example.spring.kafka.springkafka.config;

import com.example.spring.kafka.springkafka.message.ReceiptInfo;
import com.example.spring.kafka.springkafka.message.UserInfo;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringSerializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.core.DefaultKafkaProducerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

import java.util.HashMap;

/**
 * Kafka로 메시지를 전송하기 위한 팰토리와 템플릿을 정의한다.
 */
@Configuration
public class KafkaProducerConfig {

    @Value(value = "${kafka.address}")
    private String address;

    /**
     * 스트링 기반의 메시지를 전송하기 위한 팰토리 설정
     * 이때 주키퍼 서버의 주소, 키 시리얼라이징 방식, 값 시리얼라이징 방식을 지정한다.
     * @return 생산자 팩토리를 전송한다.
     */
    @Bean
    public ProducerFactory<String, String> producerFactory() {
        final HashMap<String, Object> configProps = new HashMap<>();
        configProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, address);
        configProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        configProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);

        return new DefaultKafkaProducerFactory<>(configProps);
    }

    /**
     * KafkaTemplate 을 생성한다. 이때 사용하고자 하는 팩토리를 지정하게 된다.
     * @return
     */
    @Bean
    public KafkaTemplate<String, String> kafkaTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }

    /**
     * 사용자 정보 객체를 전달한다. 이때 JSON 으로 시리얼라지 되도록 JsonSerializer 를 적용하고 있다.
     * @return 생산자 팩토리를 전송한다.
     */
    @Bean
    public DefaultKafkaProducerFactory receiptInfoProducerFactory() {
        final HashMap<String, Object> configProps = new HashMap<>();
        configProps.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, address);
        configProps.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        configProps.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class);
        return new DefaultKafkaProducerFactory<>(configProps);
    }

    /**
     * KafkaTemplate을 생성한다. 사용자 정보를 전달하도록 지정했다.
     * @return
     */
    @Bean
    public KafkaTemplate<String, ReceiptInfo> receiptInfoKafkaTemplate() {
        return new KafkaTemplate<>(receiptInfoProducerFactory());
    }
}

```

### 카프카 ConsumerConfig 생성하기

ConsumerConfig 는 메시지를 수신하는 이벤트를 받는 역할을 하는 빈을 등록한다. <br/>
ConsumerFactory는 메시지를 consume 하는 객체를 생성하는 팩토리이다. <br/>
그리고 이를 이용하여 카프카 리스너를 생성한다. 리스너를 생성할때 kafka 팩토리가 전달된다. 

```java
package com.example.spring.kafka.springkafka.config;

import com.example.spring.kafka.springkafka.message.ReceiptInfo;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory;
import org.springframework.kafka.core.ConsumerFactory;
import org.springframework.kafka.core.DefaultKafkaConsumerFactory;
import org.springframework.kafka.support.serializer.JsonDeserializer;

import java.util.HashMap;
import java.util.Map;

@EnableKafka
@Configuration
public class KafkaConsumerConfig {

    @Value(value = "${kafka.address}")
    private String address;

    /**
     * 컨슈머 팩토리를 생성한다. 이때 그룹 아이디는 컨슈머를 그룹으로 지정하고, 동일한 그룹은 동일한 파티션만을 바라보게 처리할 수 있도록 한다.
     * @param groupId 지정하고자 하는 그룹 아이디
     * @return 컨슈머 팩토리
     */
    public ConsumerFactory<String, String> consumerFactory(String groupId) {
        final HashMap<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, address);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);

        return new DefaultKafkaConsumerFactory<>(props);
    }

    /**
     * UserInfo 를 카프카로부터 받아와서 디시리얼라이징 한다.
     * @return 컨슈머 팩토리
     */
    public ConsumerFactory<String, ReceiptInfo> receiptInfoConsumerFactory() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, address);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "userInfo");
        return new DefaultKafkaConsumerFactory<>(props, new StringDeserializer(), new JsonDeserializer<>(ReceiptInfo.class));
    }

    /**
     * 일반적인 스트링 기반의 디시리얼라이징 처리를 수행하며,
     * 그룹은 결과를 받도록 처리한다.
     * @return 리스너 팩토리 반환
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, String> resultKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, String> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory("result"));
        return factory;
    }

    /**
     * 사용자 정보를 수신받고 디시리얼라이징 한다.
     * @return 리스너 팩토리 반환
     */
    @Bean
    public ConcurrentKafkaListenerContainerFactory<String, ReceiptInfo> userInfoKafkaListenerContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<String, ReceiptInfo> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(receiptInfoConsumerFactory());
        return factory;
    }

}

```

### MessageProducer 로 실제 메시지를 생성하는 객체 만들기 

메시지 프로듀서는 카프카 템플릿을 이용하여 실제 카프카 토픽으로 메시지를 전달하는 역할을 한다. 

```java
package com.example.spring.kafka.springkafka.message;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class MessageProducer {
    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @Autowired
    private KafkaTemplate<String, ReceiptInfo> receiptInfoKafkaTemplate;

    @Value(value = "${receipt.topic.name}")
    private String receiptTopicName;

    @Value(value = "${result.topic.name}")
    private String resultTopicName;

    @Value(value = "${partition.topic.name}")
    private String partitionTopicName;

    public void sendReceiptInfoMessage(ReceiptInfo receiptInfo) {
        log.info("Send ReceiptInfo to kafka queue {} ", receiptInfo);
        receiptInfoKafkaTemplate.send(receiptTopicName, receiptInfo);
    }

    public void sendResultMessage(String message) {
        log.info("Send ReceiptResult to kafka queue {} ", message);
        kafkaTemplate.send(resultTopicName, message);
    }

    public void sendLogMessateToPartition(String key, String message, int partition) {
        kafkaTemplate.send(partitionTopicName, partition, key, message);
    }

}

```

### MessageConsumer 객체 생성하여 메시지 수신하기. 

MessageConsumer 는 메시지 리스너를 이용하여 (이전 KafakConsumerConfig 에 등록한 빈) Kafka로 부터 메시지를 수신받는다. <br/>
이때 @KafkaListener 를 이용하여 특정 토픽과, 팩토리를 지정할 수 있다. 

```java
package com.example.spring.kafka.springkafka.message;

import com.example.spring.kafka.springkafka.processor.LoggingService;
import com.example.spring.kafka.springkafka.processor.UserInfoProcessService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.annotation.TopicPartition;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class MessageConsumer {

    @Autowired
    UserInfoProcessService userInfoProcessService;

    @Autowired
    MessageProducer messageProducer;

    @Autowired
    LoggingService loggingService;

    @KafkaListener(topics = "${receipt.topic.name}", containerFactory = "userInfoKafkaListenerContainerFactory")
    public void listenUserInfo(ReceiptInfo receiptInfo) {
        loggingService.logging("Received Messasge : " + receiptInfo);
        if (receiptInfo != null && receiptInfo.getReceiptId() != null) {
            receiptInfo.setReceiptCode(ReceiptCode.PROCESSING);
            userInfoProcessService.saveUserInfo(receiptInfo);

            loggingService.logging("Process Some Process :" + receiptInfo.getReceiptId());

            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            receiptInfo.setReceiptCode(ReceiptCode.RECEIPTED);
            userInfoProcessService.saveUserInfo(receiptInfo);

            messageProducer.sendResultMessage(String.valueOf(receiptInfo.getReceiptId()));

        }
        else {
            loggingService.logging("Not Valid User Info : " + receiptInfo);
            return;
        }


    }

    @KafkaListener(topics = "${result.topic.name}", groupId = "result", containerFactory = "resultKafkaListenerContainerFactory")
    public void listenGroupBar(String message) {
        loggingService.logging("Received Messasge in group 'result': " + message);
    }

    @KafkaListener(topicPartitions = @TopicPartition(topic = "${partition.topic.name}", partitions = { "0", "1", "2", "3", "4" }))
    public void listenToParition(@Payload String message, @Header(KafkaHeaders.RECEIVED_PARTITION_ID) int partition) {
        log.info("Received LOG Message: " + message + " from partition: " + partition);
    }
}

```

### 각종 작업을 처리하는 Service 생성하기. 

#### CommonService 

CommonService 의 역할은 접수 아이디를 생성하고, 클라이언트로 저장된 ReceiptInfo 를 컨커런트 해시맵에 저장한다. <br/>
이는 샘플 테스트를 위해 만든 임시 객체로, 이부분은 DataBase 부분으로 대체하면 좋을듯 하다. 

```java
package com.example.spring.kafka.springkafka.processor;

import com.example.spring.kafka.springkafka.message.ReceiptInfo;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

public class CommonService {

    static ConcurrentHashMap userInfoMap = new ConcurrentHashMap();

    static AtomicLong receiptIdInfo = new AtomicLong();

    public static Long getReceiptId() {
        return receiptIdInfo.incrementAndGet();
    }

    public static void saveReceiptInfo(ReceiptInfo receiptInfo) {
        userInfoMap.putIfAbsent(receiptInfo.getReceiptId(), receiptInfo);
    }

    public static ReceiptInfo findReceiptInfo(Long receiptId) {
        return (ReceiptInfo)userInfoMap.get(receiptId);
    }
}

```

#### LoggingService

LoggingService 는 파티셔닝 토픽을 이용하여 로깅을 하는 샘플을 보여주기위한 서비스이다.<br/> 
이 서비스를 이용하여 로그를 남기면, 파티션에 나눠서 로깅을 전달한다. 
```java
package com.example.spring.kafka.springkafka.processor;

import com.example.spring.kafka.springkafka.message.MessageProducer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class LoggingService {

    @Autowired
    MessageProducer messageProducer;

    @Value("${partition.count}")
    private int partitionCount;

    public void logging(String message) {
        final long epoch = System.currentTimeMillis();
        final int partition = (int)(epoch % partitionCount);
        messageProducer.sendLogMessateToPartition("key", epoch + " : " + message, partition);
    }
}

```

#### ReceiptService

ReceiptService 는 컨트롤러로 부터 접수를 받으면 접수 아이디를 따고, 메시지를 카프카로 전달하는 역할을 한다. <br/>
혹은 접수 아이디에 해당하는 객체를 CommonService 로부터 조회하는 기능을 가진다. 

```java
package com.example.spring.kafka.springkafka.processor;

import com.example.spring.kafka.springkafka.message.MessageProducer;
import com.example.spring.kafka.springkafka.message.ReceiptCode;
import com.example.spring.kafka.springkafka.message.ReceiptInfo;
import com.example.spring.kafka.springkafka.message.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReceiptService {

    @Autowired
    private MessageProducer messageProducer;

    public Long receiptUserInfo(UserInfo userInfo) {
        final Long receiptId = CommonService.getReceiptId();

        final ReceiptInfo receiptInfo = new ReceiptInfo(receiptId, ReceiptCode.RECEIPTED, userInfo);
        messageProducer.sendReceiptInfoMessage(receiptInfo);

        return receiptId;
    }

    public ReceiptInfo getUserInfo(Long receiptId) {

        final ReceiptInfo info = CommonService.findReceiptInfo(receiptId);
        if (info == null) {
            return new ReceiptInfo(receiptId, ReceiptCode.FAILED, null);
        }

        return info;
    }
}

```

#### UserInfoProcessService

UserInfoProcess 는 요청접수 내용을 저장하거나, 접수번호로 해당 요청 정보를 조회한다. 

```java
package com.example.spring.kafka.springkafka.processor;

import com.example.spring.kafka.springkafka.message.ReceiptInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class UserInfoProcessService {

    @Autowired
    LoggingService loggingService;

    public void saveUserInfo(ReceiptInfo receiptInfo) {
        loggingService.logging("Save ReceiptInfo Info : " + receiptInfo);
        CommonService.saveReceiptInfo(receiptInfo);
    }

    public ReceiptInfo getUserInfoByReceiptId(Long receiptId) {
        return CommonService.findReceiptInfo(receiptId);
    }
}

```

#### ReceiptController 

ReceiptController 는 클라이언트 단으로부터 요청을 접수 받거나, 접수번호로 해당 정보를 조회하는 역할을 한다. 

```java
package com.example.spring.kafka.springkafka.reception;

import com.example.spring.kafka.springkafka.message.MessageProducer;
import com.example.spring.kafka.springkafka.message.ReceiptInfo;
import com.example.spring.kafka.springkafka.message.UserInfo;
import com.example.spring.kafka.springkafka.processor.ReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/receipt")
public class ReceiptController {

    @Autowired
    MessageProducer producer;

    @Autowired
    ReceiptService receiptService;

    @PostMapping("/user-info")
    public Long receiptUserInfo(@RequestBody UserInfo userInfo) {
        return receiptService.receiptUserInfo(userInfo);
    }

    @GetMapping("/user-info/{receiptId}")
    public ReceiptInfo getUserInfo(@PathVariable Long receiptId) {
        return receiptService.getUserInfo(receiptId);
    }
}

```

### 서버 실행하기 

기본적으로 스프링 부트로 서버를 올리면 8080 서버로 동작할 것이다. <br/>
다음 메시지를 전송해서 우리가 개발한 처리가 정상적으로 수행되는지 확인하자.<br/>

```curl
curl -X POST \
  http://localhost:8080/receipt/user-info \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: b3545bb6-a427-1c43-a6cc-e637d24d4164' \
  -d '{
"name":"KIDO",
"age":40,
"height":177,
"weight":75
}'
``` 

결과 로그를 확인해보면, 메시지가 다음과 같은 형태로 전달될 것이다. 

```java
21:09:05.561 [http-nio-8080-exec-1] INFO  o.a.c.c.C.[Tomcat].[localhost].[/] - Initializing Spring FrameworkServlet 'dispatcherServlet'
21:09:05.561 [http-nio-8080-exec-1] INFO  o.s.web.servlet.DispatcherServlet - FrameworkServlet 'dispatcherServlet': initialization started
21:09:05.577 [http-nio-8080-exec-1] INFO  o.s.web.servlet.DispatcherServlet - FrameworkServlet 'dispatcherServlet': initialization completed in 16 ms
21:09:05.693 [http-nio-8080-exec-1] INFO  c.e.s.k.s.message.MessageProducer - Send ReceiptInfo to kafka queue ReceiptInfo(receiptId=1, receiptCode=RECEIPTED, userInfo=UserInfo(name=KIDO, age=40, height=177.0, weight=75.0)) 

...

21:09:05.781 [org.springframework.kafka.KafkaListenerEndpointContainer#0-0-C-1] INFO  o.a.kafka.common.utils.AppInfoParser - Kafka version : 1.0.2
21:09:05.781 [org.springframework.kafka.KafkaListenerEndpointContainer#0-0-C-1] INFO  o.a.kafka.common.utils.AppInfoParser - Kafka commitId : 2a121f7b1d402825
21:09:05.794 [org.springframework.kafka.KafkaListenerEndpointContainer#2-0-C-1] INFO  c.e.s.k.s.message.MessageConsumer - Received LOG Message: 1540296545786 : Save ReceiptInfo Info : ReceiptInfo(receiptId=1, receiptCode=PROCESSING, userInfo=UserInfo(name=KIDO, age=40, height=177.0, weight=75.0)) from partition: 1
21:09:05.795 [org.springframework.kafka.KafkaListenerEndpointContainer#2-0-C-1] INFO  c.e.s.k.s.message.MessageConsumer - Received LOG Message: 1540296545786 : Process Some Process :1 from partition: 1
21:09:05.795 [org.springframework.kafka.KafkaListenerEndpointContainer#2-0-C-1] INFO  c.e.s.k.s.message.MessageConsumer - Received LOG Message: 1540296545778 : Received Messasge : ReceiptInfo(receiptId=1, receiptCode=RECEIPTED, userInfo=UserInfo(name=KIDO, age=40, height=177.0, weight=75.0)) from partition: 3
21:09:06.290 [org.springframework.kafka.KafkaListenerEndpointContainer#0-0-C-1] INFO  c.e.s.k.s.message.MessageProducer - Send ReceiptResult to kafka queue 1 
21:09:06.294 [org.springframework.kafka.KafkaListenerEndpointContainer#2-0-C-1] INFO  c.e.s.k.s.message.MessageConsumer - Received LOG Message: 1540296546289 : Save ReceiptInfo Info : ReceiptInfo(receiptId=1, receiptCode=RECEIPTED, userInfo=UserInfo(name=KIDO, age=40, height=177.0, weight=75.0)) from partition: 4
21:09:06.303 [org.springframework.kafka.KafkaListenerEndpointContainer#2-0-C-1] INFO  c.e.s.k.s.message.MessageConsumer - Received LOG Message: 1540296546300 : Received Messasge in group 'result': 1 from partition: 0
```

접수 아이디로 조회하기 

```curl
curl -X GET \
  http://localhost:8080/receipt/user-info/1 \
  -H 'cache-control: no-cache' \
  -H 'postman-token: 5e7faae1-b03a-6123-ed96-ae55e4be5609'
```

결과는 다음과 같이 반환된다. 

```java
{
    "receiptId": 1,
    "receiptCode": "RECEIPTED",
    "userInfo": {
        "name": "KIDO",
        "age": 40,
        "height": 177,
        "weight": 75
    }
}
```

### Github
You can find full sources from [github](https://github.com/unclebae/spring-kafka)

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


