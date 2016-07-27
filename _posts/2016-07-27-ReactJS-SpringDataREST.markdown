---
layout: post
title: React.js와 Spring Data REST 따라하기(Part1)
---

this article from [spring.io](https://spring.io/guides/tutorials/react-and-spring-data-rest/)

## 기본적인 사항 
[Spring Data REST](https://www.youtube.com/watch?v=TgCr7v9tdKM) : 
빠르게 리포지토리의 내용을 REST방식으로 지원해준다. 

[React](http://facebook.github.io/react/index.html) :
Facebook에서 개발한 자바스크립트 컴포넌트로 효과적이면서도, 빠르고 쉽게 사용할 수 있는 뷰 컴포넌트이다.

## 준비물

### spring starter

[http://start.spring.io](http://start.spring.io) 에서 다음 항목을 선택하고 프로젝트 스텁을 만들자. 

- Rest Repository : Spring Data REST를 지원
- Thymeleaf : View를 생성해주는 최근 스프링에서 밀어주는 View컴포넌트 
- JPA : Java Persistance API
- H2 : 메모리 DB, 테스트 용도로 매우 가볍고 편리한 도구
- Lombok : boilerplate 한 코드를 자동 생성해주는 도구 

### 설치과정 with Eclipse
신규 프로젝트 생성

![react_spring01](/img/react_spring/react_spring01.png)

프로젝트 설정 

![react_spring02](/img/react_spring/react_spring02.png)

프로젝트 의존성 설정 

![react_spring03](/img/react_spring/react_spring03.png)

### 기타 개발환경 
- Java 8
- Maven Project
- 최신 release의 Spring Boot
- React.js

## 스프링 데이터 REST를 왜 사용하나?
초기 데이터가 있으며, 사용자는 다양한 방법으로 이 데이터에 접근하길 원한다. 시간이 흐르고 사람들은 많은 수의 MVC 컨트롤러를 
생산해내었고, 스프링에서 제공하는 강력한 REST를 지원했다. 그러나 점점 시간이 갈수록 유지보수 비용이 증가한다. 

Spring Data REST는 이러한 문제를 다음과 같은 방법으로 해결한다. 

- 개발자는 Spring Data를 이용하여 리포지토리 모델을 제공한다. 
- HTTP verbs (GET, POST, DELETE, PUT등을 말한다.) 와 표준 미디어 타입들 그리고 IANA-approved 한 링크 이름을 이용하여 표준화를 제공한다.

## 도메인 선언하기. 
Spring Data REST 기반의 어플리케이션에서 중요한 부분은 domain object이다. 
다음은 Employee 라는 도메인 객체를 생성하는 코드이다. 

src/main/java/com/unclebae/study/entity/Employee.java

{% highlight java %}

package com.unclebae.study.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

@Data
@Entity
public class Employee {

	private @Id @GeneratedValue Long id;
	private String firstName;
	private String lastName;
	private String description;
	
	private Employee() {}
	
	public Employee(String firstName, String lastName, String description) {
		this.firstName = firstName;
		this.lastName = lastName;
		this.description = description;
	}
}
{% endhighlight %}

```@Entity```는 JPA 어노테이션으로 관련된 테이블에 저장되어야할 클래스를 의미한다. 
```@Id```와 ```@GeneratedValue```는 기본키를 의미하며, 필요한경우 자동적으로 생성되는 의미의 JPA어노테이션이다. 
```@Data```는 Lombok 어노테이션이며 getter, setter, constructors, toString, hash, equals, 기타 boilerplate한 코드를 생성해준다. 

이 엔터티는 employee의 정보를 담는데 사용한다. 이 케이스에서는 이름과 job 설명을 담게 된다. 

* Spring Data REST는 JPA만 한정되어 사용되지 않는다. 다양한 NoSQL 데이터 저장소 역시 사용할 수 있으며, 인터페이스의 변경 없이 그대로 사용이 가능하다. 

## Repository 정의하기. 
Spring Data REST어플리케이션에서 주요 부분중에 하나는 repository 정의 부분이다. 

src/main/java/com/unclebae/study/repository/EmployeeRepository.java

{% highlight java %}

package com.unclebae.study.repository;
import org.springframework.data.jpa.repository.CrudRepository;
import com.unclebae.study.entity.Employee;

public interface EmployeeRepository extends CrudRepository<Employee, Long> {

}
{% endhighlight %}

- repository는 Spring Data 공통으로 CrudRepository를 상속받는다. 그리고 도메인 객체의 타입과 primary key필드의 타입을 지정한다. 

## Demo 데이터 미리 로드하기. 
어플리케이션이 실행이 될때, 몇개의 데이터를 미리 로드해보자. 

src/main/java/com/unclebae/study/loader/DatabaseLoader.java

{% highlight java %}

package com.unclebae.study.loader;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.unclebae.study.entity.Employee;
import com.unclebae.study.repository.EmployeeRepository;

@Component
public class DatabaseLoader implements CommandLineRunner {

	private final EmployeeRepository repository;
	
	@Autowired
	public DatabaseLoader(EmployeeRepository repository) {
		this.repository = repository;
	}
	
	@Override
	public void run(String... arg0) throws Exception {
		repository.save(new Employee("Kido", "Bae", "Computer Engineer"));
		repository.save(new Employee("Uncle", "Bae", "Computer Scientist"));
	}

}
{% endhighlight %}

- 이 클래스에서는 ```@Component```어노테이션을 기술하고 있으며 이는 ```@SpringBootApplication```에서 자동으로 찾도록한다.
- 스프링 부트에서 제공해주는 ```CommandLineRunner```를 구현하였으며, 이는 모든 Bean들이 생성되고, 등록된후에 실행이 된다. 
- ```EmployeeRepository``` 객체는 생성자를 이용하여 DI된다. 
- ```run()```메소드는 커맨드라인이 실행될때 호출되는 메소드이며, 여기에서 기초 데이터를 저장하고 있다. 

Spring Data에서 가장 강력한 기능중에 하나는 JPA쿼리를 생성해준다는 것이다. 이것은 개발 시간을 줄여줄 뿐만 아니라. 버그와 에러를 줄여주는
역할을 한다. Spring Data는 리포지토리 클래스에서 [메소드 이름에 의한 쿼리 생성](http://docs.spring.io/spring-data/jpa/docs/current/reference/html/#repositories.query-methods.details)을 지원하며 필요한 saving, deleting, finding 등의 기능을 제공한다. 

### root URI 변경하기. 
기본적으로 Spring Data REST의 호스트는 / 를 root로 하고 있다. 이 root URI는 주로 UI를 위해 사용하므로 api를 위해서 다음과 같이 변경하자. 

src/main/resources/application.properties

{% highlight shell %}
spring.data.rest.base-path=/api
{% endhighlight %}

### 어플리케이션 런칭하기. 
마지막 스텝으로 어플리케션이 REST의 API의 오퍼레이션을 fully하게 지원하기 위해서 다음과 같이 코드를 작성한다. 

src/main/java/com/unclebae/study/ReactSpringDataRestApplication.java

{% highlight java %}

package com.unclebae.study;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ReactSpringDataRestApplication {

	public static void main(String[] args) {
		SpringApplication.run(ReactSpringDataRestApplication.class, args);
	}
}
{% endhighlight %}

해당 어플리케이션을 실행해보자. ```./mvnw spring-boot:run```으로 수행하거나 이클립스에서 수행하자. 

글에서 추천하는 스프링 부트 강의 [Josh Long](https://www.youtube.com/watch?v=sbPSjI4tt10)

## 테스트 해보기. 
어플리케이션이 올라오면 [cURL](http://curl.haxx.se/)을 이용하여 테스트를 해보자. 

curl localhost:8080/api

{% highlight shell %}
{
  "_links" : {
    "employees" : {
      "href" : "http://localhost:8080/api/employees"
    },
    "profile" : {
      "href" : "http://localhost:8080/api/profile"
    }
  }
}
{% endhighlight %}

root노드로 요청을 던지면 위와 같은 결과가 [HAL-formatted JSON docuemnt](http://stateless.co/hal_specification.html)로 감싸져서 반환된다. 

- ```_links```는 가능한 링크의 컬렉션들을 반환한다. 
- ```employees``` 는 EmployeeRepository인터페이스에 의해서 정의된 객체를 위한 aggregate root를 나타낸다. 
- ```profile``` 는 IANA-standard 와 연관된 내용이며 이는 전체 서비스의 메타데이터를 발견하도록 표시한다. 

## employees 링크에 접근해보기
curl localhost:8080/api/employees

{% highlight shell %}
{
  "_embedded" : {
    "employees" : [ {
      "firstName" : "Kido",
      "lastName" : "Bae",
      "description" : "Computer Engineer",
      "_links" : {
        "self" : {
          "href" : "http://localhost:8080/api/employees/1"
        },
        "employee" : {
          "href" : "http://localhost:8080/api/employees/1"
        }
      }
    }, {
      "firstName" : "Uncle",
      "lastName" : "Bae",
      "description" : "Computer Scientist",
      "_links" : {
        "self" : {
          "href" : "http://localhost:8080/api/employees/2"
        },
        "employee" : {
          "href" : "http://localhost:8080/api/employees/2"
        }
      }
    } ]
  },
  "_links" : {
    "self" : {
      "href" : "http://localhost:8080/api/employees"
    },
    "profile" : {
      "href" : "http://localhost:8080/api/profile/employees"
    }
  }
}
{% endhighlight %}

위 내용을 보면 employees로 2개의 내용이 들어 있음을 알 수 있다. 
하나는 ```http://localhost:8080/api/employees/1``` 그리고 다른 하나는 끝이 2인 정보가 있다는 것을 알려준다. 

맨 아래 내용은 현재 URL의 정보와 profile정보를 보여주고 있다. 

## employee상세 정보 살펴보기. 
curl localhost:8080/api/employees/1

{% highlight shell %}

{
  "firstName" : "Kido",
  "lastName" : "Bae",
  "description" : "Computer Engineer",
  "_links" : {
    "self" : {
      "href" : "http://localhost:8080/api/employees/1"
    },
    "employee" : {
      "href" : "http://localhost:8080/api/employees/1"
    }
  }
}
{% endhighlight %}

## 신규 데이터 입력해보기. 

신규로 데이터를 넣고자 할때에는 다음과 같이 명령어를 입력하면 된다. 

curl -X POST localhost:8080/api/employees -d '{"firstName":"Bilbo", "lastName":"Baggins", "description": "burglar"}' -H 'Content-Type:application/json'
{% highlight java %}
{
  "firstName" : "Bilbo",
  "lastName" : "Baggins",
  "description" : "burglar",
  "_links" : {
    "self" : {
      "href" : "http://localhost:8080/api/employees/3"
    },
    "employee" : {
      "href" : "http://localhost:8080/api/employees/3"
    }
  }
}
{% endhighlight %}

다음 가이드를 보고 PUT, PATCH, DELETE등의 verbose를 이용할 수 있다. [참고 가이드](https://spring.io/guides/gs/accessing-data-rest/)


