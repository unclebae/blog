---
layout: post
title:
comments: true
---

## Mysql Query Execution Plan 알아보기. 
EXPLAIN 스테이트먼트는 MYSQL 실행에 대한 정보를 획득하는데 사용한다. 

- explainable 한 구문은 SELECT, DELETE, INSERT, REPLACE, UPDATE 등이 가능하다. 
- EXPLAIN은 구문을 실행하기 위한 옵티마이저 정보를 디스플레이한다. Mysql의 explain은 구문을 어떻게 실행할지, 
	어떤테이블이 서로 조인이 될지에 대한 정보를 나타낸다. 
- FOR Connection connection_id 과 함께 사용될때에는 named connection내의 스테이트 먼트 실행에 대해서 나타낸다. 
- MySQL 5.7.3 이전에서 EXPLAIN EXTENDED 는 추가적인 execution plan정보를 얻을 수 있었다. 이제는 EXTENDED는 디폴트로 채택되고 있다. 
- MySQL 5.7.3 이전에서 EXPLAIN PARTITIONS는 파티션된 테이블에 대해서 실행될때 유용한 정보를 보여준다. 이후 버젼부터는 partitions 는 자동적으로 디폴트로 지정되어 있다. 
- FORMAT 옵션은 select 출력 포맷을 지정할 수 있다. 전통적으로는 tabular 형색의 포맷이 사용된다. 기본값은 no FORMAT이며, JSON 포맷을 이용하면 json형식의 데이터를 볼 수 있다. FORMAT = JSON 으로 기술한다. 

EXPLAIN은 다음과 같은 이점이 있다. 
- 테이블 어디에 인덱스를 주어야할지 알 수 있게 해준다. 
- 테이블 조인시 어떠한 순서로 조인이 되어야 효율적인지 알 수 있다. 
- 조인 순서를 힌트를 이용하여 줄 수 있다. select straight_join을 이용하면 from 순서대로 조인이 이루어진다. 다만 이를 이용하면 semi-join transformation이 disable된다는 것을 기억해야한다. 

인덱스 수행에 문제가 있다면, analyze table를 실행하여 통계 정보를 업데이트 할 수 있다. 통계정보는 옵티마이저가 채택할 키의 카디널리티 값 등의 통계 데이터를 업데이트 하는 역할을 한다. 



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

