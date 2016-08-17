---
layout: post
title: Using powermock with junit 4.12
comments: true
---

# Powermock + Junit 4.12
powermock은 Mockito등과 같은 모업 유틸과 함께 사용되어 다양한 확장 기능을 수행할 수 있도록 하고 있다. 

## 설정하기. 

공식 사이트 : https://github.com/jayway/powermock/wiki/MockitoUsage

## Junit 4.12버젼 충돌 해결하기. 

{% highlight java %}
testCompile 'junit:junit:4.12',
            'org.powermock:powermock-core:1.6.1',
            'org.powermock:powermock-module-junit4:1.6.1',
            'org.powermock:powermock-api-mockito:1.6.1'
{% endhighlight %}

## Powermock 간단 사용하기. 

정적 메소드 이용해보기. 
예) ```boolean result = TestStringUtils.isNumber("12345");```
위와같이 들어온 글자가 숫자인지 검사한는 정적 메소드가 있어서 모킹이 어렵다면 다음과 같이 해결하자. 

{% highlight java %}
@RunWith(PowerMockRunner.class)
@PrepareForTest( { TestStringUtils.class })
public class YourTestCase {

    @Test
    public void TestMock() {
        PowerMockito.mockStatic(TestStringUtils.class);
        when(TestStringUtils.isNumber(anyString())).thenReturn(true);

        ... 이후 테스트 수행 ...
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

