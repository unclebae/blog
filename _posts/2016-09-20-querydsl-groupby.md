---
layout: post
title: QueryDSL Group By 처리하기. 
comments: true
---

Query DSL로 Group By 처리를 수행하여 집계 연산 결과를 받아오는 테스트를 수행해보자. 

아래 예제는 여러건의 집계 결과를 리스트로 받아오는 테스트이다. 

우선 StatusSummary라는 결과를 담아올 객체를 생성한다. 

StatusSummary.java

{% highlight java %}
@Data
@AllArgsConstructor(access = AccessLevel.PUBLIC)
public class StatusSummary {

    @NotNull
    private Long id;

    @NotNull
    private Long statusCode;

    @NotNull
    private Integer counts;
}
{% endhighlight %}

결과를 받아오는 쿼리 DSL구문 

{% highlight java %}
QUserStatus table = QUserStatus.userStatus;

JPAQuery query = new JPAQuery(entityManager);

// 뽑은 결과를 StatusSummay에 담을 것이기 때문에 표현식을 생성한다. 
ConstructorExpression<StatusSummary> constructor = Projections.constructor(StatusSummary.class, table.id, table.statusCode, Wildcard.countAsInt);

List<CSReturnStatusSummary> list = query.from(table)
        .where(table.id.in(ids)
            .and(table.status.in("AAA", "BBB")))
        .groupBy(table.id, table.status)  // groupBy를 수행할 필드 나열
        .list(constructor);
{% endhighlight %}

그룹 키를 이용하여 Map 형태로 받아오기. 
transform을 이용하면 다양한 형태의 자료구조로 변환이 가능하다. 

{% highlight java %}
import static com.querydsl.core.group.GroupBy.*;

Map<Integer, List<Comment>> results = query.from(post, comment)
    .where(comment.post.id.eq(post.id))
    .transform(groupBy(post.id).as(list(comment)));
{% endhighlight %}

복수개의 칼럼이 존대한다면 다음과 같이 Group로 담아낸다. 
이를 이용하여 postID를 키로하고, 값은 Group가 되며 내부에는 post.name과 comment.id의 셋으로 접근이 가능하다. 

{% highlight java %}
Map<Integer, Group> results = query.from(post, comment)
    .where(comment.post.id.eq(post.id))
    .transform(groupBy(post.id).as(post.name, set(comment.id)));

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

