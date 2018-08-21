---
layout: post
title: The Reactive Manifesto
comments: true
---
# Reactive Manifesto 요약
원문 : https://www.reactivemanifesto.org/

## 배경
- 서로 분리되어 있는 조직에서 업무를 수행하는 조직들은 소프트웨어 빌딩을 위한 독립적인 패턴을 가지고 있다.
- 이러한 시스템은 더욱 견고하고, 더 회복이 쉬우며, 더욱 유연하고 현대의 요구사항을 더욱 쉽게 수용할 수 있다. 

- 이러한 변화는 최근 몇년간 드라마틱한 요규사항의 변경으로 인한 것이다. 
- 불과 몇 년전까지만 해도 큰 시스템이라고 하면 섭 10대정도에 수 초의 응답시간, 수 시간의 오프라인 관리, 그리고 기가바이트의 데이터 정도였다.
- 오늘날에는 수천개의 멀티코어 프로세서로 클라우드 기반의 클러스터를 구성하며, 모바일 디바이스에서 수없이 데이터가 들어온다. 사용자는 수밀리 세컨드 이내의 응답 속도를 원하며 100% 업타임을 요구한다. 
데이터는 이미 페타바이트로 측정이 된다. 오늘날의 요구는 어제의 소프트웨어 아키텍처로 단순하게 구성이 어렵다.

- 오늘날 우리가 원하는 시스템은 Responsive, Resilient, Elastic 그리고 Massage Driven 시스템을 원한다. 
- 이러한 시스템을 Reactive System 이라고 한다. 

- reactive System 으로 시스템을 빌드 하는 것은 더욱 유연하고, 루즈드 커플드 되어 있으며, 확장성이 있다. 
- 이러한 특징은 개발을 더 쉽게 하고, 변경에 대해서 쉽게 대응하도록 한다.  
- 또한 장애에 대해서 내성이 있게 하며, 장애가 재앙이 되는 것이 아니라 우아하게 대처할 수 있도록 해준다.
- Reactive System 들은 높은 응답성을 지니며, 사용자에게 인터렉티브한 피드백을 준다. 

## Reactive System의 특징 : 

### Responsive : 
- 시스템은 가능하면 즉각적으로 반응한다. 
- 응답성은 사용성, 기능성의 초석이다. 응답성의 의미는 문제가 빠르게 디텍트 되도록하며, 효과적으로 관리하는 것이다. 
- 응답성 있는 시스템은 빠르고 일관적인 응답 시간을 제공하며, 일관적인 QoS를 특정 선 이상으로 제공하는 것을 말한다. 
- 이러한 일관성 잇는 행위는 에러 처리를 간편하게 하고, 엔드 유저에게 확실성을 제공한다. 그리고 앞으로의 인터렉션을 권정하는 역할을 한다.

### Resilient :
- 시스템이 장애에 있을때 응답성을 유지하는 것을 말한다. 
- 이것은 Highly-Available를 제공하는 것 뿐만 아니라. 미션 크리티컬 시스템을 제공한다. Resilient 하지 못한 시스템은 장애가 발생된 이후 응답이 없게 될 것이다. 
- Resilience는 replication(복제), containment(방지), isolation(고립) 그리고 delegation(전달) 을 통해서 달상된다.
- 실패들은 각 컴포넌트 내에 포함된다. 다른 컴포넌트들로 부터 실패를 고립 시키고, 그러므로 해서 시스템의 일부분만 실패하고, 전체 시스템에 문제를 주지 않고 회복하도록 한다. 
- 각 컴포넌트의 복구는 다른 컴포넌트들로 전파가 되며, HA는 복제를 통해서 보장이 된다. 
- 컴포넌트의 클라이언트들은 실패를 다루기 위한 부담이 줄어들게 된다. 

### Elastic : 
- 시스템은 다양한 워크로드로 부터 응답성을 유지해야한다.
- 리액티브 시스템은 변경에 대해서 반응을 하며 이는 리소스의 증가/감소 에 의해서 인풋의 변화에 반응하는 것이다. 
- 이러한 디자인은 논란의 여지를 줄여주고, 중앙의 보틀넥이 없다.
- Reactive System은 예측가능하고, 반응성이 있으며, 유의미한 성능측정으로 확장 알고리즘을 제공한다. 
- 이러한 거들이 비용효과적인 elasticity를 달성할수 있는 것으로 하드웨어, 소프트웨어에 공통으로 적용된다. 

### Message Driven : 
- Reactive System 은 비동기 메시지 패싱을 통해서 각 컴포넌트 간의 경계사이에 통신을 수행한다.
- 이는 느슨한 커플링을 보장하고, 고립, 위치 투명성을 제공한다. 이러한 바운더리는 메시지를 통한 장애 전파로도 사용된다. 
- 명시적인 메시지 패싱은 로드관리를 가능하게 하고, elasticity, flow control 을 수행할 수 있도록 하며, 시스템의 메시지 큐를 컨트롤 하거나, 필요한경우 back-pressure를 제공한다. 
- 위치 투명성 메시징은 커뮤니케이션 수단으로 동일한 방식의 실패 관리를 가능하게 한다. 그리고 클러스터간에 통일성을 제공한다.
- Non-blocking 커뮤니케이션은 수신자가 적은 시스템 오버헤드로 해당 메시지를 처리하도록 한다. 
  


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

