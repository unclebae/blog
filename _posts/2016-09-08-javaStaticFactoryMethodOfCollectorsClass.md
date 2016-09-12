---
layout: post
title: StaticFactory Methods of Collectors Class in Java
comments: true
---

## 자바 컬렉션 클래스의 정적 Factory메소드 알아보기. 

|Factory method|Returned Type| Used to|
|toList|List<T>|스트림의 아이템을 list로 반환한다. |
|ex||List<Dish> dishes = menuStream.collect(toList());|
|toSet|Set<T>|스트림의 아이템을 set으로 반환한다. 중복은 제거된다.|
|ex||Set<Dish> dishes = menuStream.collect(toSet());|
|toCollection|Collection<T>|스트림의 아이템을 컬렉션으로 넣는다. 이는 제공된 supplier에 의해서 생성된다.|
|ex||Collection<Dish> dishes = menuStream.collect(toCollection(), ArrayList::new);|
|counting|Long|스트림의 아이템을 센다.|
|ex||long howManyDishes = menuStream.collect(counting());|
|summingInt|Integer|스트림의 아이템의 정수 프로피터의 총 값을 계산한다.|
|ex||int totalCalories = menuStream.collect(summingInt(Dish::getCalories));|
|averagingInt|Double|스트림의 아이템의 정수 프로퍼티의 평균값을 계산한다.|
|ex||double avgCalories = menuStream.collect(averagingInt(Dish::getCalories));|
|summarizingInt|IntSummary-Statistics|스트림의 아이템들의 통계값을 계산한다. maximum, minimum, total, average|
|ex||IntSummaryStatistics menuStatistics = menuStream.collect(summarizingInt(Dish::getCalories));|
|joining|String|스트림의 각 아이템에서 toString의 호출 결과들을 연결한다.|
|ex||String shortMenu = menuStream.map(Dish::getName).collect(joining(","));|
|maxBy|Optional<T>|주어진 comparator에 의해서 최대 엘리먼트를 구하여 Optional로 감싼값을 반환하거나 빈 Optional값을 반환한다.|
|ex||Optional<Dish> fattest = menuStream.collect(maxBy(comparingInt(Dish::getCalories)));|
|minBy|Optional<T>|주어진 comparator에 의해서 최소 엘리먼트를 구하여 Optional로 감싼값을 반환하거나 빈 Optional값을 반환한다.|
|ex||Optional<Dish> lightest = menuStream.collect(minBy(comparingInt(Dish::getCalories)));|
|reducing|reducing오퍼레이션으로 생성된 타입|Binary오퍼레이터를 이용하여 누적값이나 반복적으로 연결된 값을 반환하며, 초기값에서 부터 이러한 연산을 한다.|
|ex||int totalCalories = menuStream.collect(reducing(0, Dish::getCalories, Integer::sum));|
|collectingAndthen|변환함수의 결과 타입을 반환한다.|다른 컬렉터와 변환 함수 처리된 결과를 반환한다.|
|ex||int howManyDishes = menuStream.collect(collectingAndThen(toList(), List:size));|
|groupBy|Map<K, List<T>>|스트림의 아이템들을 그루핑한다. 이는 프로퍼티중의 하나를 기준으로 그루핑되며, 결과 맵에 해당 값이 들어간다.|
|ex||Map<Dish.Type, List<Dish>> dishesByType = menuStream.collect(groupingBy(Dish::getType));|
|partitioningBy|Map<Boolean, List<T>>|스트림의 아이템의 파티션을 반환한다. 이는 각각의 predicate에 따라 파티션된다.|
|ex||Map<Boolean, List<Dish>> vegetarianDishes = menuStream.collect(partitioningBy(Dish::isVegetarian));|


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

