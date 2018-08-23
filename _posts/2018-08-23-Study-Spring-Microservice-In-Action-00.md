---
layout: post
title: [스터디] 스프링 마이크로 서비스 인 액션
comments: true
---
# 스프링 마이크로 서비스 인 액션
마이크로 서비스 아키텍처는 이제 대세인가보다. 

예전 Monolithic 아키텍처로는 대규모의 시스템을 개발 운영하는데 많은 에너지가 소모된다.
버젼관리, 개발진행중 발생되는 컨플릭, 장애를 해당 발생 지점에 고립시키지 못하고 전체 시스템에 재앙을 초래 하기도 한다.

최근 나는 티맵 택시 설계를 담당하면서 Spring Cloud를 활용하여 MSA를 설계하고 구현하였다.
각각의 서비스 컴포넌트 레이어를 분리하고, 자신의 관심사에 대한 처리만 수행할 수 있도록 컴포넌트별 역할을 명확히 하였고, 레이어 사이에 커뮤니케이션 패스가 DAG 구조를 가지고 처리될 수 있도록 노력했던 기억이 난다.

MSA 시스템을 설계하고, 구현하면서 많은 것을 배웠지만 다시 처음으로 하나하나 차근차근 다듬어 나간다는 마음으로 이 책을 선정했다. 
책의 내용을 요약하고, 내 나름대로 정리를 해볼 것이다.

본 아티클의 핵심은 같이 공부해보자는 것이다. 기본으로 돌아가서 하나씩 체계적으로...

## 스터디 도서 
- Spring Microservice in Action

### Contents 
1. Welcome to the cloud, Spring
2. Building microservices with Spring Boot
3. Controlling your configuration with Spring Cloud configuration server
4. On service discovery
5. When bad things happen: client resiliency patterns with Spring Cloud and Netflix Hystrix
6. Service routing with Spring Cloud and Zuul
7. Securing your microservices
8. Event-driven architecture with Spring Cloud Stream
9. Distributed tracing with Spring Cloud Sleuth and Zipkin
10. Deploying your microservices
appendix A. appendix A Running a cloud on your desktop
appendix B. appendix B OAuth2 grant types

뭔가 목차만 봐도 흥미 진진할꺼 같다. 

이제 천천히 하나씩 스터디 한 내용을 올려볼 것이다. 
 

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

