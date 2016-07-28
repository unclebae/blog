---
layout: post
title: HAL - Hypertext Application Language
comments: true
---

[from](http://stateless.co/hal_specification.html)

## 개요
HAL은 단순한 포맷으로 일관성있고, 쉬운 방법으로 API에서 리소스들 간의 hyperlink를 기술하도록 해준다. 

HAL을 채택하기 위해서는 API를 탐험할 수 있어야 하며, API그 자체를 쉽게 확인할 수 있도록 문서화 되어야한다. 
이렇게 되면 당신의 API가 단순해지며, 사용하기 더 쉬워진다. 그렇게 되면 클라이언트 개발자들에게 매력적인 API를 제공할 수 있다. 

API 에 HAL을 채택하면 쉽게 서비스를 할 수 있으며, 대부분  메이저 프로그래밍 에서 오픈 소스 라이브러리를 쉽게 이용할 수 있게 할 수 있다.
이는 매우 단순하며, 다른 JSON을 이용하는 것과 같이 쉽게 이용할 수 있다. 

## Quick links

- [A demo API using HAL called HAL Talk](http://haltalk.herokuapp.com/)
- [A list of libraries for working with HAL (Obj-C, Ruby, JS, PHP, C#, etc.)](https://github.com/mikekelly/hal_specification/wiki/Libraries)
- [A list of public hypermedia APIs using HAL](https://github.com/mikekelly/hal_specification/wiki/APIs)
- [Discussion group (questions, feedback, etc)](http://groups.google.com/group/hal-discuss)

## 일반적인 개요 
HAL은 JSON이나 XML 등으로 하이퍼링크를 표현하기 위한 편리한 셋을 제공한다. 

```이후 HAL도큐먼트라고 하는것은 단순한 JSON 혹은 XML을 의미한다. ```

ad-hoc 구조를 이용하거나 혹은 자신만의 포맷을 만들기 위해서 소중한 시간을 사용하는것 대신에 HAL의 편리함을 채택할 수 있다. 그리고 데이터를 만들고 도큐멘팅 하는 것에 집중할 수 있다. 

HAL은 HTML과 유사한 메커니즘을 가진다. 일반적이며, 많은 다른 타입의 어플리케이션에 hyperlink를 이용한 설계를 하게 해준다. 
HTML과 다른점은 HTML은 사용자의 목적을 위해 웹 어플리케이션을 통해서 사용자를 이동할 수 있도록 도와주는 기능을 가지고 있다. 반면 HAL은 자동화된 actor들이 자신의 목적을 위해 웹 어플리케이션을 이동할 수 있도록 해주는데 있다. 

말한바와 같이 HAL은 매우 human-friendly 하다. 이는 API 메시지 그 자체에서 필요한 API를 찾아낼 수 있도록 해준다. 이는 또한 개발자가 HAL기반의 API를 직접적으로 확인하게 해주며, 필요한 웹 탐험을 위한 추가적인 문서를 인식해야하는 오버헤드 없도록 해준다. 

## 예제 
아래 예제는 hal+json의 컬렉션을 보여준다. 다음 제시한 기능들을 확인해보자. 

- main 리소스의 URI는 /order 로 표현되며 self link로 표시하고 있다. 
- 'next' 링크는 orders의 다음 페이지를 나타낸다. 
- 'ea:find'는 id를 통해서 검색을 하기 위해 호출되도록 하는 템플릿화된 링크이다. 
- 복수개의 'ea:admin' 링크 객체들은 배열내에 포함되어 있다. 
- orders 컬렉션의 2개 속성은 'currentlyProcessing'과 'shippedToday'이다. 
- 내장된 order리소스는 자신의 links와 properties들을 가진다. 
- 압축된 URI는 'ea'로 이름되어 있으며 이는 자신의 문서 URL의 링크의 이름이다. 

### application/hal+json


{% highlight json %}
{
    "_links": {
        "self": { "href": "/orders" },
        "curies": [{ "name": "ea", "href": "http://example.com/docs/rels/{rel}", "templated": true }],
        "next": { "href": "/orders?page=2" },
        "ea:find": {
            "href": "/orders{?id}",
            "templated": true
        },
        "ea:admin": [{
            "href": "/admins/2",
            "title": "Fred"
        }, {
            "href": "/admins/5",
            "title": "Kate"
        }]
    },
    "currentlyProcessing": 14,
    "shippedToday": 20,
    "_embedded": {
        "ea:order": [{
            "_links": {
                "self": { "href": "/orders/123" },
                "ea:basket": { "href": "/baskets/98712" },
                "ea:customer": { "href": "/customers/7809" }
            },
            "total": 30.00,
            "currency": "USD",
            "status": "shipped"
        }, {
            "_links": {
                "self": { "href": "/orders/124" },
                "ea:basket": { "href": "/baskets/97213" },
                "ea:customer": { "href": "/customers/12369" }
            },
            "total": 20.00,
            "currency": "USD",
            "status": "processing"
        }]
    }
}
{% endhighlight %}

## HAL Model
HAL 규칙은 2개의 단순한 개념을 이용한다. :Resources와 Links가 그것이다. 

### Resources 
Resources는 다음과 같은 내용을 가진다.  

- Links : URI를 를 가리킨다. 
- 내장된 리소스
- State 

### Links
Links는 다음과 같은 내용을 가진다. 

- A target (a URI)
- A relation aka. 'rel' (링크의 이름이다.)
- 추가적인 다른 옵션 속성으로 deprecation, content negotiation, 등이 있다. 

아래 이미지는 HAL의 구조를 표현한 러프한 이미지이다. 
![Hal-image](/img/hal/info-model.png)

## HAL이 API에서 어떻게 사용되나?
HAL은 API구성을 위해서 설계되었다. 이것은 클라이언트가 links를 통해서 리소스를 이동할 수 있도록 한다. 

Links는 link 연관에 의해서 정의된다. Link relation들은 hypermedia API의 생명선과 같다. 이것은 클라이언트 개발자에게
어떠한 리소스가 가능하고, 어떻게 이들과 상호작용하는지 알려준다. 그리고 어떻게 링크를 탐험하는지 선택하는 코드를 작성하게된다.

Link relation은 HAL에서 단순히 스트링으로만 정의하는 것은 아니다. 이는 실제 URL이며 이를 통해 주어진 링크를 읽어들이기 위해 따라갈 수 있다. 이것은 "discoverability"라고 알려진 것이다. 이 아이디어는 개발자는 API내부로 들어올 수 있으며 가능한 링크를 통해서 문서를 읽고, API를 통해서 다른 링크를 따라갈 수 있다는 것이다. 

HAL은 link relations를 사용하기를 장려한다. 

- link 정의 그리고 내장된 리소스를 함께 표현한다. 
- 예상된 구조 그리고 대상 리소스의 의미를 추론한다. 
- 어떠한 리퀘스트와 표현식들이 타겟 리소스로 submit될수 있는지 알려준다. 

## 어떻게 HAL을 서비스 하는가?
HAL은 JSON과 XML두 미디어 타입을 가진다. 이는 application/hal+json과 application/hal+xml 으로 각각 기술된다. 
HTTP를 통해서 HAL을 서비스 할때 Content-Type은 관련된 미디어 타입 이름을 포함하게 된다. 

## HAL document의 구조 

### 최소 적법한 document 
하나의 HAL문서는 반드시 비어있는 리소스라도 포함하고 있어야한다. 

#### 비어있는 JSON 객체 

{% highlight json %}
{}
{% endhighlight %}

### Resources 
대부분의 케이스에서 resources는 자기자신을 가리키는 URL을 가진다. 
다음 예에서는 ```self``` 링크를 통해서 표현하고 있다. 

{% highlight json %}
{
	"_links": {
		"self": { "href": "/example_resource" }
	}
}
{% endhighlight %}

### Links
Links는 반드시 리소스를 직접적으로 포함해야한다. 
Links는 JSON객체와 같은식으로 표현되며 _links를 포함하다. 이는 반드시 직접적인 resource object의 속성이어야한다. 

{% highlight json %}
{
	"_links": {
		"next": { "href": "/page=2" }
	}
}
{% endhighlight %}

### Link Relations
Links 는 relation ('rel'이라고함) 을 가져야한다. 이는 구문적으로 특정 링크를 의미한다. 

Link rels는 리소스들의 링크를 구별하는  주요한 방법이다. 

이것은 기본적으로 _links hash 와 함께 단지 키이며, 연결된 링크는 실제 'href' 값과 같은 데이터를 포함하는 객체의 링크를 의미한다.

{% highlight json %}
{
	"_links": {
		"next": { "href": "/page=2" }
	}
}
{% endhighlight %}

### API Discoverability
Link rels는 URL이어야한다. 이것은 주어진 링크로 문서가 나타나며, 이를통해 "discoverable"하게 만든다. URL은 일반적으로 길며,
키로 사용하기에는 형편없다. 이것때문에 HAL은 "CURIEs"를 제공한다. 이는 기본적으로 이름지어진 토큰으로 문서내에 정의할 수 있으며, link relation URI를 표현한다. 줄임 표현으로 "http://example.com/rels/widget"대신에 ex:widget을 이용할 수 있다. 

### Representing Multiple Links with The Same Relation 
리소스는 복수개의 링크를 가진다. 이것은 동일한 link relation을 공유한다. 
link relations를 위해서 다음과 같이 복수개의 links를 배열에 넣은 예는 다음과 같다. 

{% highlight json %}
{
	"_links": {
		"items": [{
			"href": "/first_item"
		}, {
			"href": "/second_item"
		}]
	}
}
{% endhighlight %}

노트 : 만약 링크가 한개가 있는지 확신할 수 없다면 복수개라고 가정하는것이 좋다. 만약 하나라고 가정하고 있는데 이것이 변경되어야
한다는 것을 알게되면 새로운 링크 relation을 생성해야할 것이다. 혹은 존재하는 클라이언트는 깨지거나 할 것이다. 

### CURIEs
"CURIE"는 리소스 도큐먼트에 접근하기 위한 링크를 제공하는데 도움을 준다.

HAL은 예약된 link relation을 제공하며 'curies'라고 한다. 이는 리소스 도큐먼트의 로케이션에 대한 힌트를 이용할 수 있게 해준다. 

{% highlight json %}
{
	"_links": {
		"curies": [
		{
			"name": "doc"
			,"href": "http://haltalk.herokuapp.com/docs/{rel}"
			,"templated": true
		}
		],
		"doc:latest-posts": {
			"href": "/posts/latest"
		}
	}
}
{% endhighlight %}

'curies'섹션에서는 복수개의 link가 올 수 있다. 이는 "name"과 templated된 'href'가 오며 이는 반드시 {rel}플레이스 홀더를 포함해야한다. 

Links는 자신의 'rel'로 변경이 가능하다. 이는 CURIE이름으로 변경이 된다. latest-posts링크는 doc도큐먼트로 링크되며 CURIE는 'rel'에 doc:latest-posts를 세팅한다. 

latest-posts리소스에 대한 도큐먼트를 조회하기 위해서 클라이언트는 연관된 CURIE링크를 실제 link의 rel로 확장한다.
이 처리 결과는 http://haltalk.herokuapp.com/docs/latest-posts가 되며 이것은 이 리소스에 해당하는 도큐먼트를 반환하게 된다. 

## 결론 :
HAL은 간편하게 사용할 수 있는 REST API의 도큐먼트 구조를 제공하는 것으로 보인다. 
거의 표준이 되지 않을까? 싶은데... ^^ 잘몰것음. 

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
	         var d = document, s = d.createElement('script');
			         
			         s.src = '//https-unclebae-github-io.disqus.com/embed.js';
					         
					         s.setAttribute('data-timestamp', +new Date());
							         (d.head || d.body).appendChild(s);
									     })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
    <script id="dsq-count-scr" src="//https-unclebae-github-io.disqus.com/count.js" async></script>

{% endif %}
