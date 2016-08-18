---
layout: post
title: Powermock MockitoUsage
comments: true
---

from : [https://github.com/jayway/powermock/wiki/MockitoUsage](https://github.com/jayway/powermock/wiki/MockitoUsage)

# powermock과 mockito를 연동하여 사용하기.


## 소개

기본적으로 PowerMock은 "PowerMockito" 라고 불리는 클래스를 제공하며 이는 mock/object/class를 생성하는 작업과 초기화, 검증, 기대에 대한 작업을 수행할 수 있으며 이는 그대로 Mockito를 이용하여 이러한 작업을 할 수 있다. 

모든 사용에는 ```@RunWith(PowerMockRunner.class)```와 ```@PrepareForTest``` 어노테이션을 클래스 레벨에서 필요로 한다. 


## 지원버젼 

|Mockito|PowerMock|
|2.0.0-beta - 2.0.42-beta|1.6.5+|
|1.10.8 - 1.10.x|1.6.2+|
|1.9.5-rc1 - 1.9.5|1.5.0 - 1.5.6|
|1.9.0-rc1 & 1.9.0|1.4.10 - 1.4.12|
|1.8.5|1.3.9 - 1.4.9|
|1.8.4|1.3.7 & 1.3.8|
|1.8.3|1.3.6|
|1.8.1 & 1.8.2|1.3.5|
|1.8|1.3|
|1.7|1.2.5|

---

## 사용법 

아래 예제에서는 static import를 이용하지 않는다. 여기서는 Mockito, PowerMockito를 그대로 이용하여 이해를 쉽게 할 것이다. 실제 사용할때에는 static import 메소드를 사용할 것을 권장한다. 이는 읽기를 향상 시킬 것이다. 

---

### Mocking Static Method 이용하기. 

Step 1. 
@PrepareForTest를 클래스 레벨에 걸어준다. 

{% highlight java %}
@PrepareForTest(Static.class) // Static.class 는 정적 메소드를 포함하는 클래스이다.
{% endhighlight %}

Step 2.
PowerMockito.mockStatic() 을 호출한다. 이는 PowerMockito.spy(class)를 이용하도록 정적 메소드를 사용 등록한다. 
{% highlight java %}
PowerMockito.mockStatic(Static.class);
{% endhighlight %}

Step 3. 
Mockito.when() 을 이용하여 필요한 기대값을 지정한다. 
{% highlight java %}
Mockito.when(Static.firstStaticMethod(param)).thenReturn(value);
{% endhighlight %}

---

#### behavior 검증방법

static method의 검증은 다음 2가지 스텝으로 가능하다. 

1. 우선 PowerMockito.verifyStatic()을 호출하고, 행위를 검증한다. 그리고 
2. static method를 호출하여 검증한다. 

{% highlight java %}
PowerMockito.verifyStatic(); // 1
Static.firstStaticMethod(param); // 2
{% endhighlight %}

- 중요 : verifyStatic()을 각 검증메소드 마다 호출해야한다. 

---

#### 아규먼트 매처를 어떻게 사용하는가?

모키토 매처는 아마도 PowerMock 목에 적용될 것이다. 예를 들어 커스텀 아규먼트 매처를 각 목된 정적 메소드에 적용할 수 있다. 

{% highlight java %}
PowerMockito.verifyStatic();
Static.thirdStaticMethod(Mockito.anyInt());
{% endhighlight %}

---

#### 어떻게 정확하게 호출 카운트를 셀 수 있을까?

Mockito.VerificationMode를 이용할 수 있다. (예) Mockito.times(x) 이며 이는 PowerMockito.verifyStatic(Mockito.times(2))이용하게 된다. 

{% highlight java %}
PowerMockito.verifyStatic(Mockito.times(1));
{% endhighlight %}

---

#### 어떻게 void static 메소드의 exception을 던지는 것을 스텁할 수 있는가?

만약 private 아니라면 
{% highlight java %}
PowerMockito.doThrow(new ArrayStoreException("Mock error")).when(StaticService.class);
StaticService.executeMethod();
{% endhighlight %}

동일하게 final classes/methods에도 적용할 수 있다. 
{% highlight java %}
PowerMockito.doThrow(new ArrayStoreException("Mock error")).when(myFinalMock).myFinalMethod();
{% endhighlight %}

private 메소드에는 PowerMockito.when 을 이용한다. 
{% highlight java %}
when(tested, "methodToExpect", argument).thenReturn(myReturnValue);
{% endhighlight %}

---

#### 전체 예제

{% highlight java %}
@RunWith(PowerMockRunner.class)
@PrepareForTest(Static.class)
public class YourTestCase {
    @Test
    public void testMethodThatCallsStaticMethod() {
        // mock all the static methods in a class called "Static"
        PowerMockito.mockStatic(Static.class);
        // use Mockito to set up your expectation
        Mockito.when(Static.firstStaticMethod(param)).thenReturn(value);
        Mockito.when(Static.secondStaticMethod()).thenReturn(123);

        // execute your test
        classCallStaticMethodObj.execute();

        // Different from Mockito, always use PowerMockito.verifyStatic() first
        // to start verifying behavior
        PowerMockito.verifyStatic(Mockito.times(2));
        // IMPORTANT:  Call the static method you want to verify
        Static.firstStaticMethod(param);


        // IMPORTANT: You need to call verifyStatic() per method verification, 
        // so call verifyStatic() again
        PowerMockito.verifyStatic(); // default times is once
        // Again call the static method which is being verified 
        Static.secondStaticMethod();

        // Again, remember to call verifyStatic()
        PowerMockito.verifyStatic(Mockito.never());
        // And again call the static method. 
        Static.thirdStaticMethod();
    }
}
{% endhighlight %}

---

### 부분 모킹 

PowerMockito.spy를 이용하여 부분 모킹을 이용할 수 있다. 주의할 것은 (다음은 Mockito 문서에서 획득한 것으로 PowerMockito에 잘 적용된다.)

가끔 spy들을 스터빙 하기위해 when(...)을 직접 이용하지 않아도 된다. 

예제)
{% highlight java %}
List list = new LinkedList();
List spy = spy(list);
//Impossible: real method is called so spy.get(0) throws IndexOutOfBoundsException (the list is yet empty)
when(spy.get(0)).thenReturn("foo");

//You have to use doReturn() for stubbing
doReturn("foo").when(spy).get(0);
{% endhighlight %}

---

#### behavior 검증방법 

Mockito.verify()를 이용하여 검증이 가능하다. 

{% highlight java %}
Mockito.verify(mockObj, times(2)).methodToMock();
{% endhighlight %}

---

#### private behavior 검증하기. 

PowerMockito.verifyPrivate()를 이용한다. 

{% highlight java %}
verifyPrivate(tested).invoke("privateMethodName", argument1);
{% endhighlight %}

이것은 또한 private static methods로 동작한다. 

---

#### 새로운 객체의 생성자를 어떻게 목을 하는가?

PowerMockito.whenNew를 이용한다. 

{% highlight java %}
whenNew(MyClass.class).withNoArguments().thenThrow(new IOException("error message"));
{% endhighlight %}

테스트를 위해서 MyClass의 인스턴스를 생성을 위해서 준비해야한다. 만약 클래스를 new MyClass()가 X에 호출되면 당신은 @PrepareForTest(X.class)를 수행해야한다. 이는 whenNew를 위한 작업이다. 

{% highlight java %}
@RunWith(PowerMockRunner.class)
@PrepareForTest(X.class)
public class XTest {
        @Test
        public void test() {
                whenNew(MyClass.class).withNoArguments().thenThrow(new IOException("error message"));

                X x = new X();
                x.y(); // y is the method doing "new MyClass()"

                ..
        }
}
{% endhighlight %}

---

#### 객체 생성의 검증방법

PowerMockito.verifyNew를 이용한다. 
{% highlight java %}
verifyNew(MyClass.class).withNoArguments();
{% endhighlight %}

---

#### 아규먼트 매처 이용방법 

Mockito 매처를 PowerMock에 그대로 이용할 수 있다. 
{% highlight java %}
Mockito.verify(mockObj).methodToMock(Mockito.anyInt());  
{% endhighlight %}

---

#### spying예제 전체보기. 

{% highlight java %}
@RunWith(PowerMockRunner.class)
// We prepare PartialMockClass for test because it's final or we need to mock private or static methods
@PrepareForTest(PartialMockClass.class)
public class YourTestCase {
    @Test
    public void spyingWithPowerMock() {        
        PartialMockClass classUnderTest = PowerMockito.spy(new PartialMockClass());

        // use Mockito to set up your expectation
        Mockito.when(classUnderTest.methodToMock()).thenReturn(value);

        // execute your test
        classUnderTest.execute();

        // Use Mockito.verify() to verify result
        Mockito.verify(mockObj, times(2)).methodToMock();
    }
}
{% endhighlight %}

---

#### private메소드의 부분 모킹 예제 

{% highlight java %}
@RunWith(PowerMockRunner.class)
// We prepare PartialMockClass for test because it's final or we need to mock private or static methods
@PrepareForTest(PartialMockClass.class)
public class YourTestCase {
    @Test
    public void privatePartialMockingWithPowerMock() {        
        PartialMockClass classUnderTest = PowerMockito.spy(new PartialMockClass());

        // use PowerMockito to set up your expectation
        PowerMockito.doReturn(value).when(classUnderTest, "methodToMock", "parameter1");

        // execute your test
        classUnderTest.execute();

        // Use PowerMockito.verify() to verify result
        PowerMockito.verifyPrivate(classUnderTest, times(2)).invoke("methodToMock", "parameter1");
    }
}  
{% endhighlight %}


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

