---
layout: post
title: Tomcat JDBC Connection Pool 소개
comments: true
---

from: [https://tomcat.apache.org/tomcat-7.0-doc/jdbc-pool.html](https://tomcat.apache.org/tomcat-7.0-doc/jdbc-pool.html)

## 소개 
```org.apache.tomcat.jdbc.pool```은 Apache Commons DBCP커텍션 풀의 대용으로 사용된다. 

### 사용이유

1. Common DBCP 1.x 버젼은 단일 쓰레드로 동작한다. 전체 풀의 공통적인 lock에 대해서 thread safe 한 처리를 위해서 사용되며, Common DBCP 2.x에서는 달라졌다. 
2. Common DBCP 1.x 는 느리다. 논리적인 CPU의 증가와 현재 concurrent threads가 풀을 빌려오고, 반환하는 량이 증가하는 경우 성능상 많은 문제가 발생한다. 높은 병렬처리 시스템에서는 이는 문제가 될 수 있다. Common DBCP 2.x버젼에서는 달라졌다. 
3. Common DBCP는 60개 이상의 클래스를 가진다. tomcat-jdbc-pool은 8개의 클래스로 동작한다. 그러므로 기능의 변화를 위해서 작은 수정으로도 가능하다. 
4. Common DBCP는 정적 인터페이스를 이용한다. 이 의미는 JRE의 올바른 버젼을 사용해야한다는 말이다. 그렇지 않으면 NoSuchMethodException 보게 될 것이다. 
5. 60개의 클래스를 사용하지 않고서도 충분히 간단한 구현을 할 수 있다. 
6. Tomcat jdbc pool은 비동기적으로 커넥션을 탐색할 수 있다. 이를 위해 추가적으로 스레드를 사용할 필요가 없다. 
7. Tomcat jdbc pool은 톰캣 모듈이다. 이것은 Tomcat JULI에 의존하며, 톰캣 내에 사용된 로깅 프레임워크를 이용한다. 
8. javax.sql.PooledConnection인터페이스를 통해서 커넥션을 가져올 수 있다. 
9. 풀 고갈에 대한 starvation을 막기 위해서 pool이 비어있는경우 스레드는 커넥션을 기다린다. 커넥션이 반환되면 올바르게 스레드 대기중인 객체를 깨우게 된다. 대부분의 풀은 단순히 starve된다.

### 추가 된 기능들

1. 높은 병렬처리 환경이나 멀티코어/cpu시스템에서 사용이 가능하다. 
2. 동적 인터페이스의 구현을 수행한다. 이는 java.sql과 javax.sql인터페이스를 제공하며, 비록 낮은 버젼의 JDK 에서도 컴파일이 가능하다. 
3. 검증 인터벌 - 커넥션을 사용하기 위해서 매번 validate하지 않아도 된다. 단지 커넥션을 빌리고 반환하면 된다.
4. Run-Once쿼리 설정가능한 쿼리는 한번만 실행이 된다. 이는 커넥션이 데이터베이스와 상호 연결을 할때 수행이 되며 이는 세션 설정시 매우 유용하다 그리고 원하는경우 전체 시간에 걸쳐서 커넥션이 설정된 상태로 남는다.
5. 커스텀 인터셉터 설정이 가능하며, 인터셉터를 이용하여 쿼리 상태를 수집하고, 세션 상태를 캐시하며, 실패한 커넥션을 다시 접속하도록 한다. 또한 쿼리를 재시도 하며, 쿼리 결과를 캐시하는 등의 작업을 한다. 
6. 고성능 : 이후에 서로다른 성능관련 내역을 보여줄 것이다. 
7. 매우 단순하며, 단순한 구현으로 만들어졌다. 소스 파일이나 길이는 c3po에 비해서 매우 짧으며, 버그도 매우 적다. 단지 8개의 클래스로 구성되며, 커넥션 풀은 그 절반정도 된다. 버그가 발견이되면, 매우 빠르게 찾아낼 수 있으며 쉽게 수정이 가능하다.  
8. 비동기 커넥션 획득 : 커넥션을 위해 큐에 요청을 할 수 있으며, Future<Connection>을 통해서 수신 받는다. 
9. 더 쉽게 idle 커넥션을 컨트롤 할 수 있으며, 이는 커넥션을 직접 접근하는 것대신에 초기 풀의 개수와 idle풀의 개수를 지정할 수 있다. 
10. 어느 시점에 커넥션이 버려질지 결정할 수 있다. 풀이 꽉 찻을때, 그리고 idle풀의 크기등에 대해서 스마트 알고리즘증으로 수행가능하다. 
11. 커넥션ㅇ르 버리는 타이머는 statement/query 액티비티에 동작한다. 
12. 특정타임동안 커넥션을 사용하고 커넥션을 닫는다. 
13. JMX노티를 얻는것과 커넥션이 서스펙트 되어고 버려지게 되는 경우에 rev
14. 커넥션은 java.sql.Driver, javax.sql.DataSource, javax.sql.XADataSource 이는 dataSource, dataSourceJNDI 속성으로 이용이 가능하다. 
15. XA커넥션을 제공한다. 

### 예제코드 

#### 데이터 소스 생성을 위한 단순 예제 소스 

{% highlight java %}
  import java.sql.Connection;
  import java.sql.ResultSet;
  import java.sql.Statement;

  import org.apache.tomcat.jdbc.pool.DataSource;
  import org.apache.tomcat.jdbc.pool.PoolProperties;

  public class SimplePOJOExample {

      public static void main(String[] args) throws Exception {
          PoolProperties p = new PoolProperties();
          p.setUrl("jdbc:mysql://localhost:3306/mysql");
          p.setDriverClassName("com.mysql.jdbc.Driver");
          p.setUsername("root");
          p.setPassword("password");
          p.setJmxEnabled(true);
          p.setTestWhileIdle(false);
          p.setTestOnBorrow(true);
          p.setValidationQuery("SELECT 1");
          p.setTestOnReturn(false);
          p.setValidationInterval(30000);
          p.setTimeBetweenEvictionRunsMillis(30000);
          p.setMaxActive(100);
          p.setInitialSize(10);
          p.setMaxWait(10000);
          p.setRemoveAbandonedTimeout(60);
          p.setMinEvictableIdleTimeMillis(30000);
          p.setMinIdle(10);
          p.setLogAbandoned(true);
          p.setRemoveAbandoned(true);
          p.setJdbcInterceptors(
            "org.apache.tomcat.jdbc.pool.interceptor.ConnectionState;"+
            "org.apache.tomcat.jdbc.pool.interceptor.StatementFinalizer");
          DataSource datasource = new DataSource();
          datasource.setPoolProperties(p);

          Connection con = null;
          try {
            con = datasource.getConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("select * from user");
            int cnt = 1;
            while (rs.next()) {
                System.out.println((cnt++)+". Host:" +rs.getString("Host")+
                  " User:"+rs.getString("User")+" Password:"+rs.getString("Password"));
            }
            rs.close();
            st.close();
          } finally {
            if (con!=null) try {con.close();}catch (Exception ignore) {}
          }
      }
  }
{% endhighlight %}

#### JNDI lookup 샘플 

{% highlight java %}
<Resource name="jdbc/TestDB"
          auth="Container"
          type="javax.sql.DataSource"
          factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
          testWhileIdle="true"
          testOnBorrow="true"
          testOnReturn="false"
          validationQuery="SELECT 1"
          validationInterval="30000"
          timeBetweenEvictionRunsMillis="30000"
          maxActive="100"
          minIdle="10"
          maxWait="10000"
          initialSize="10"
          removeAbandonedTimeout="60"
          removeAbandoned="true"
          logAbandoned="true"
          minEvictableIdleTimeMillis="30000"
          jmxEnabled="true"
          jdbcInterceptors="org.apache.tomcat.jdbc.pool.interceptor.ConnectionState;
            org.apache.tomcat.jdbc.pool.interceptor.StatementFinalizer"
          username="root"
          password="password"
          driverClassName="com.mysql.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/mysql"/>
{% endhighlight %}

#### 비동기 커넥션 획득 

다음은 추가적인 쓰레드 풀 라이브러리 필요없이 비동기 커넥션 획득을 수행할 수 있다. 
커넥션 획득은 Future<Connection> getConnectionAsync()를 통해서 수행이 가능하다. 
비동기 획득을 위해서는 다음 2가지 상태가 반드시 되어야한다. 

1. fairQueue설정을 true로 해두어야한다. 
2. 데이터 소스를 org.apache.tomcat.jdbc.pool.DataSource 데이터 소스로 변경해야한다.

{% highlight java %}
Connection con = null;
  try {
    Future<Connection> future = datasource.getConnectionAsync();
    while (!future.isDone()) {
      System.out.println("Connection is not yet available. Do some background work");
      try {
        Thread.sleep(100); //simulate work
      }catch (InterruptedException x) {
        Thread.currentThread().interrupt();
      }
    }
    con = future.get(); //should return instantly
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("select * from user");
{% endhighlight %}

### 속성값 정리

common-dbcp 에서 tomcat-dbct-pool 로 변경하는 것은 매우 단순하다. 
대부분의 속성은 동일하며 동일한 의미를 가진다. 

#### JNDI Factory and Type

|Attribute|Description|
|factory|factory는 다음과 같이 지정한다. org.apache.tomcat.jdbc.pool.DataSourceFactory|
|type|Type은 항상 javax.sql.DataSource이거나 javax.sql.XADataSource이어야한다. org.apache.tomcat.jdbc.pool.DataSource 혹은 org.apache.tomcat.jdbc.pool.XADataSource가 생성될 것이다. |

#### Common Attributes

|Attribute|Description|
|defaultAutoCommit|boolean값이며 이 풀에의해서 생성된 커넥션의 자동커밋 상태를 나타낸다. 만약 이 값이 설정되지 않으면 기본은 JDBC Driver를 따른다. 만약 설정하지 않으면 setAutoCommit 메소드는 호출되지 않을 것이다. |
|defaultReadOnly|boolean값이며, 이 풀에 의해서 생성된 커넥션의 read-only상태를 설정한다. 만약 이 값이 설정되지 않으면 setReadyOnly메소드는 호출되지 않을 것이다. (몇몇 드라이버 infomix와 같은 것은 이를 지원하지 않는다.)|
|defaultTransactionIsolation|(String) 이 풀에 의해서 생성된 커넥션의 트랜잭션 isolation을 설정한다. 자바에서 다음과 같은 것을 지원한다. <ul><li>None</li> <li>READ_COMMITTED</li> <li>READ_UNCOMMITTED</li> <li>REPEATABLE_READ</li> <li>SERIALIZABLE</li> </ul>만약 이것이 설정되지 않으면 기본적으로 JDBC드라이버의 isolation을 따른다. |
|defaultCatalog|(String)값으로 이 풀에 의해서 생성된 커넥션의 기본 카탈로그를 설정한다.|
|driverClassName|(String)fully qualified 자바 클래스로 JDBC에서 사용되어질 클래스 이름이다. 드라이버는 tomcat-jdbc.jar과 같은 동일한 클래스 로더에 의해서 접근 가능해야한다.|
|username|(String)커넥션 설정을 위한 JDBC드라이버에 전달되는 사용자 이름이다. |
|password|(String)커넥션 설정에서 JDBC드라이버에서 사용할 패스워드를 설정한다. |
|maxActive|(int)동시에 풀에서 할당하고 있는 액티브 커넥션 개수를 지정한다. 기본적으로 100이다.|
|maxIdle|(int)전체 시간동안 풀에서 유지할 커넥션의 최대 개수이다. 이값은 기본적으로 maxActive:100으로 설정이 되며, 주기적으로 체크한다. 이 주기는 minEvictableIdleTimeMillis이며 이시간보다 긴 객체는 릴리즈된다.|
|minIdle|(int)전체 시간동안 풀에서 유지할 커넥션의 최소수를 지정한다. 커넥션 풀은 테스트 쿼리에서 실패가 나는경우 제거되면서 이 수치까지 내려간다. 기본적으로 이값은 initialSize:10으로 설정이된다.|
|initialSize|(int)풀이 시작될때 생성되어지는 커넥션의 개수를 지정한다. 기본값은 10개이다.|
|maxWait|(int)가용한 커넥션이 풀에 존재하지 않을때 대기하는 시간이며 이 시간이 지나가면 예외를 던진다. 기본값은 30000(30초)이다.|
|testOnBorrow|(boolean)풀에서 커넥션을 빌려올때 validation체크를 할지 결정한다. 검증에 실패하는경우 풀에서 이 커넥션은 드랍된다. 그리고 다른 것을 빌려온다. 노트: true로 설정하게되면 validationQuery혹은 validatorClassName 파라미터가 반드시 들어가야한다. 만약 이 값이 널이면 문제가 발생된다. 기본값은 true이다.|
|testOnConnect|(boolean) 이것은 처음 커넥션이 생성될때 검증을 수행한다. 만약 실패하는 경우 SQLException이 발생된다. true로 설정하면 validationQuery, initSQL혹은 validationClassName 파라미터가 반드시 설정되어야한다. 기본값은 false이다.|
|testOnReturn|(boolean)풀로 커넥션을 반환할때 검사한다. 이값을 true로 설정하면 validationQuery혹은 validatorClassName파라미터가 설정이 되어야한다. 기본값은 false이다. |
|testWhileIdle|(boolean)idle object evictor에 의해서 동작한다. 검증에서 실패하는경우 풀에서 제거된다. 이 값을 true로 설정하면 validationQuery혹은 validatorClassName이 설정이 되어야한다. 기본 값은 false이며, 이 작업이 수행되기 위ㅣ해서는 풀 cleaner/test쓰레드가 수행되도록 설정해야한다. |
|validationQuery|(String)쿼리 문장을 입력해야하며 커넥션 풀에 대한 검증에 사용된다. 쿼리 결과 어떠한 값이 오면 성공이다. 기본값은 null이며 보통 select 1(mysql), select1 form dual(oracle), select 1 (MS sql server)|
|validationQueryTimeout|(int)validationQuery가 실패라고 인정할때까지의 시간을 지정한다. 이는 java.sql.Statement.setQueryTimeout(seconds)를 호출한다. 풀 자체에는 쿼리 타임아웃이 존재하지 않는다. 이는 기본적으로 JDBC Driver 쿼리 타임아웃을 따른다. 만약 이 값을 0이나 음수로 두면 이값은 disable된다. 기본값은 -1이다.|
|validatorClassName|(String) org.apache.tomcat.jdbc.pool.Validator 인터페이스를 구현한 검증 클래스를 지정한다. 기본값은 null이다.|
|timeBetweenEvictionRunsMillis|(int)밀리세컨의 값으로 idle connection validation/cleaner 스레드의 실행 사이에 슬립 시간을 지정한다. 이 값은 1초 이하로 설정할 수 없고 얼마나 자주  idle, 버려진 커넥션을 체크할지를 설정하는 것이다. 기본값은 5000(5초이다)|
|numTestsPerEvictionRun|(int)tomcat-jdbc-pool에서 사용되지 않는 속성|
|minEvictableIdletimeMillis|(int)풀 내에서 idle하게 존재할 수 있는 시간을 지정한다. 기본값은 60000이며 (60초이다)|
|accessToUnderlyingConnectionAllowed|(boolean)사용되지 않는 속성값이다. |
|removeAbandoned|(boolean)버려진 커넥션을 제거할지 여부, removeAbandonTimeout을 초과한경우 해당 검증을 한다. 만약 이 값을 true로 설정하면 removeAbandonedTimeout보다 긴 시간은 제거된다. 기본값은 false이다.|
|removeAbandonedTimeout|(int)버려진 커넥션이 버려지기 전까지의 시간, 기본값은 60(60초)이며 이 값은 어플리케이션상에서 가장 긴 쿼리 시간보다 길게 잡아야한다.|
|logAbandoned|(boolean) 버려진 커넥션에 대해서 스택 트레이스를 쌓을지 설정한다. 기본값은 false이다.|
|connectionProperties|(String)새로운 커넥션을 위해서 전달되어질 속성값이다. 형식은 반드시 [propertyName=property;]* 이어야한다. user과 password는 이미 전달된 값으로 여기에는 들어가지 않는다. 기본값은 null이다.|
|poolPreparedStatements|(boolean)사용되지 않는다.|
|maxOpenPreparedStatements|(int)사용되지 않는다.|

#### Tomcat JDBC의 향상된 속성값

-- 계속 --



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

