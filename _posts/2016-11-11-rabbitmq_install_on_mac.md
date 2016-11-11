---
layout: post
title: RabbitMQ Install On Mac
comments: true
---
# Local Rabbit MQ 설치 .(MAC)

## 1. xcdoe license accept처리하기 

sudo xcodebuild -license accept 

## 2. 인스톨하기. 

brew install rabbitmq

## 3. rabbit MQ 디렉토리 

cd /usr/local/Cellar/rabbitmq/3.6.1/sbin

## 4. rabbit MQ 서버 실행하기. 

./rabbitmq-server

## 5. rabbit MQ 사용자 추가하고 admin권한주기 

./rabbitmqctl add_user kido kido

./rabbitmqctl set_user_tags kido administrator

- 사용자 비번 수정하기

./rabbitmqctl change_password kido kido123

## 6. rabbit MQ 관리툴 접근하기. 

localhost:15672

## 7. vhost 신규 생성하기. 

./rabbitmqctl add_vhost kido_dev_vhost

## 8. vhost에 권한 부여하기. (설정, 읽기, 쓰기)

./rabbitmqctl set_permissions -p kido_dev_vhost kido ".*" ".*" ".*"

./rabbitmqctl set_permissions -p kido_dev_vhost kido_dev ".*" ".*" ".*"

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

