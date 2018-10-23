---
layout: post
title: Java Interview Top 10 Java Interview Question That I Recently Faced
comments: true
---
# Top 10 Java Interview Question That I Recently Faced

자바 인터뷰 퀘스천에 대한 최근 문제가 있어서 긁어왔다. 어떤게 있는지 확인해보자. 
이런 인터뷰 관련 문제들을 블로깅해서 나도 배우고, 취준생 들에게 도움을 줄 수 있을꺼 같다.  

출처 : https://dzone.com/articles/top-10-java-interview-questions-that-i-recently-fa

### 1. Evaluate Yourself on a Scale of 10 - How Good Are You in Java?

당신을 평가한다면 10점중에 얼마인가? 자바를 얼마나 잘하는가?

    - 이 질문은 자신에 정확한 확신이 없거나 혹은 자바에 능숙하지 않다면 매우 어려운 질문이다.
    - 만약 이 질문이 익숙하다면, 약간 당신을 낮게 이야기할 필요가 있다. 
    - 이후에 아마도 레벨에 대한 질문을 받게 될 것이다. 그러니 만약 10점이라고 이야기 했고, 상당히 어려운 문제에 대해서 대답을 할 수 없다면, 좋지 감점 요인이 될 것이다.
   
### 2. Explain the Difference Between Java 7 and 8

Java 7과 Java 8의 차이점을 설명하시오. 

    - 솔직히 아주 많은 차이점이 있다. 여기에서 가장 핵심적인 차이점 몇가지를 나열할 수 있다면 그걸로 충분하다. 
    - Java8의 새로운 기능을 설명 하는것이 좋을 것이다.
    - 전체 리스트는 다음 사이트를 방문하자. [Java 8 JDK](https://www.oracle.com/technetwork/java/javase/8-whats-new-2157071.html)
    - 알고 있어야 하는 가장 중요한 포인트는 다음과 같다. 
        - [Lambda expression](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html) : 
            - 새로운 언어 기능이며, Java 8에서 소개 되었다. 
            - Lambda expression은 메소드 아규먼트 혹은 데이터와 같은 코드를 함수적으로 다루게 한다.   
            - 람다 표현식은 단일 메소드 인터페이스의 인스턴스로 표현할 수 있게 해준다. (functional interface참조하기)
            
        - [Method reference](https://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html) : 
            - 이미 이름이 있는 메소드들에 대해서 람다 익스프레션을 쉽게 읽을수 있도록 제공한다.
            
        - [Default Method](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html) :
            - 이를 이용하면 라이브러리의 인터페이스에 새로운 기능을 추가할 수 있도록 해준다. 
            - 이전 버젼의 인터페이스 용으로 작성된 코드와 바이너리 호환성을 보장할 수 있게 해준다.
             
        - [Repeating annotations](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html)
            - 동일한 선언에 한번 이상의 어노테이션을 적용할 수 있다. 
           
        - [Type annotation](https://www.mscharhag.com/java/java-8-type-annotations)
            - 타입이 사용된 어디에든지 어노테이션을 적용할 수 있다. 이것은 타입 선언에서 뿐만 아니라 사용처에도 이용가능하다. 
            - 이러한 플러그 가능한 타입 시스템을 이용하면 코드에서 강력한 타입 체킹을 할 수 있다. 
            
### 3. Which Type of Collections Do you Know About?

어떠한 컬렉션 타입을 알고 있는가?
가장 중요한 컬렉션들은 다음과 같다. 
    - ArrayList
    - LinkedList
    - HashMap
    - HashSet
    
이 이후에는 아마도 언제 이러한 컬렉션들을 사용되는지 특정 케이스에 대해서 질문할 것이다. 

해당 사용에서 다른것 보다 사용성의 이점은 무엇인지, 데이터는 어떻게 저장되는지 어떠한 데이터 구조가 뒤에서 동작하게 되는가에 대해 설명한다.

이러한 질문에 대한 답은 컬렉션 타입에 대해서 가능한 많이 배워두는 것이다. 왜냐하면 이것으로 끝없는 질문을 만들어 낼 수 있기 때문이다. 

### 4. What Methods Does the Object Class Have?

Object 클래스에는 어떠한 메소드들을 가지고 있는가?

    - 가장 기본적인 부분에 대해서 얼마나 알고 있는지를 물어부는 질문이다. 
    - Object클래스 는 클래스 계층 트리에서 최 상위에 있다. 
    - 모든 클래스는 이 클래스의 자손이며, 직접 혹은 간접적으로 Object Class의 자손이다. 
    - 모든 클래스는 Object의 메소드 인스턴스를 상속받는다. 
    - 아마도 이러한 메소드들을 이용할 필요가 없을 것이다. 그러나 사용하기를 결정한다면 사용하고자 하는 클래스에 오버라이드 하거나 할 것이다. 
    - Object로 부터 상속된 메소드들은 다음과 같다.
        - ```protected Object clone() throws CloneNotSupportedException``` : 이 객체의 복제본을 생성하고 반환한다. 
        - ```public boolean equals(Object obj)``` : 이 객체와 다른 객체가 같은지를 비교한다. 
        - ```protected void finalize() throws Throwable``` : 객체에 있는 가비지 컬렉터에 의해서 호출되며, 더이상 객체가 참조되지 않을때 garbagecollection 대상으로 결정이 되면 호출된다. 
        - ```public final Class getClass()``` : 객체의 런타임 클래스를 반환한다. 
        - ```public String toString()``` : 객체를 스트링으로 변환한 값을 반환한다. 
    - notify, notifyAll 그리고 wait 메소드들은 synchronizing 부분에서 함께 사용하는 것으로 프로그램상에서 스레드 독립적으로 수행할 수 있도록 할때 사용하게 된다. 이러한 메소드들은 다음과 같은 것들이 있따. 
        - ```public final void notify()```
        - ```public final void notifyAll()```
        - ```public final void wait()```
        - ```public final void wati(long timeout)```
        - ```public final void wati(long timeout, int nanos)```
      
### 5. Why Is the String Object Immutable in Java?

왜 스트링 객체가 자바에서 불변 객체인가? 
    1. [Spring pool](https://www.journaldev.com/797/what-is-java-string-pool) 이 자바에서 스트링이 불변 객체이기 때문에 가능한 것이다. 
    이 방법은 Java Runtime가 많은 자바 힙 스페이스를 이용하는 용량을 이용한다. 왜냐하면 다른 스트링 값들이 풀 내에서 동일한 스트링 값에 참조될 수 있기 때문이다. 만약 스트링이 불변이라면 스트링 interning(스트링을 묶어두는작업)은 아마도 불가능할 것이다. 왜냐하면 만약 변수가 변경된다면 다른 변수들에도 영향을 주게 될 것이기 때문이다. 
    
    2. 만약 스트링이 불변이 아니라면, 보안상 위험할 수 있다. 예를 들어 데이터베이스 사용자 이름, 비밀번호가 데이터베이스 커넥션을 위해 전달이 될때, 소켓 프로그래밍 호스트명, 포트 상세 정보들이 스트링으로 전달된다. 스트링이 불변이기 때문에 이 값이 전달될때 변경이 불가능하다. 만약 그렇지 않으면 해커에 의해서 변경이 될 것이고, 이슈가 발생될 것이다. 
    
    3. 스트링이 불변인동안 멀티쓰레딩에서 안전하게 된다. 그리고 단일 스트링 인스턴스는 서로다른 스레드들 간에 공유될 수 있다. 이것은 synchronization 을 이용하는 것을 피하게 해주며, 명시적으로 스레드 세이프 하다.
    
    4. 스트링들은 Java classloader 에서 사용된다. 그리고 불변성은 Classloader에 의해서 올바른 클래스가 로딩될 수 있도록 안정성을 제공한다. 예를 들어 java.sql.Connection 클래스를 로딩하고자 한다고 하자 그런데 만약 클래스 이름이 myhacked.Connection 클래스로 이름이 바뀌었다면 원하지 않는 일이 발생하게 된다. 
    
    5. 스트링이 불변이기 때문에 hashcode는 생성 타임에 저장되고, 이 사유로 해시코드가 다시 계산될 필요가 없게 된다. 이것은 맵 내에서 키를 사용할때 주요 대상 객체로 선택하는 주된 이유이기도 하다. 그리고 다른 키 객체를 이요한 HashMap 보다더 빠르게 사용된다. 이 이유가 HashMap을 이용할때 스트링을 키로 이용하는 가장큰 이유이다. 
    * 추가적인 참고사항 : []Why is String immutable in Java?](https://www.journaldev.com/802/string-immutable-final-java)

### 6. What Is the Difference Between Final, Finally, Finalize?

Final, Finally, Finalize의 차이점은 무엇인가?
    - final 키워드는 특정 컨텍스트에서 오직 한번만 값이 할당되도록 해준다.  
    - finally 블록은 중요한 코드에 사용된다. 보통 커넥션을 클로즈 하거나, 스트림을 클로즈 등등에 이용된다.  finally 블록은 정상적인 케이스나 예외적인 케이스에 항상 실행이 된다. finally 블록은 try, catch 블록 다음에 온다.     
    - Finalize 메소드는 GarbageCollector 가 항상 객체를 제거하기전에 항상 호출된다. 이것은 가비지 컬렉션을 수행할때 클린업 작업을 올바르게 수행하도록 해준다.
   
### 7. What Is the Diamond Problem?

다이아몬드 문제는 자바에서 왜 multiple inheritance를 지원하지 않는지에 대한 이유를 반영한다.

만약 2개의 클래스가 있고, 이것이 공유된 수퍼클래스의 특정 메소드를 이용하고 있다면 각각 서브 클래스에 오버라이드 된다. 

그리고 만약 이 두개의 클래스를 subClass가 상속을 받게 된다면 그리고 오버라이드된 메소드를 호출하게 된다면 언어는 어떠한 클래스의 메소드를 이용해야할지 모르게 된다. 

![Diamond Problem](/img/201808/diamond-problem-multiple-inheritance.png)

우리는 이러한 문제를 다이아몬드 문제라고 한다. 

### 8. How Can You Make a Class Immutable?

어떻게 클래스를 Immutable 하게 만들수 있는가? 

이 문제는 매우 어려운 문제라고 생각한다. 이를 수행하기 위해서는 클래스를 immutable 할 수 있도록 몇가지를 고쳐야한다. 
    
    1. 클래스를 final로 선언한다. 그러면 상속을 할 수 없게 된다. 
    
    2. 모든 필드를 private 로 만든다. 그러면 직접 접근이 허용되지 않는다. 
    
    3. 변수들에 대해서 setter 메소드를 제공하지 않는다.
    
    4. 모든 변경가능성이 있는 필드들을 final로 설정한다. 그러면 값은 오직 한번만 저장된다.
    
    5. 모든 필드를 생성자를 통해서 초기화 하고, 딥 카피를 한다. 
    
    6. getter 메소드에서 객체의 클론을 수행하여 실제값을 반환하는 대신 복제된 값을 반환한다.
    
### 9. What Does Singleton Mean?
싱글톤의 의미는 무엇인가? 

싱글톤은 클래스이며 이것은 오직 하나의 인스턴스만을 허용하는 것을 말한다. 이는 정적 변수들을 포함하며, 그 자체로 private, 유니크 인스턴스를 포함한다. 

싱글톤 클래스는 객체의 인스턴스를 오직 하나만 만들고자 할때 이용된다. 단일 객체가 시스템들에서 협력이 필요한 상황에 유용하게 이용할 수 있다. 

### 10. What Is a Dependency Injection?
DI란 무엇인가?

만약 Java Enterprise Edition 혹은 스프링을 사용하여 작업을 할때 알아야 하는 사항이다. 
다음과 같은 부분들을 참조하자. [What is Dependency Injection](https://www.zoltanraffai.com/blog/different-dependency-injection-techniques/)
       

나름 참 알찬 내용같다. 
나중에 더 많은 문제들을 공유해봐야겠다. 


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

