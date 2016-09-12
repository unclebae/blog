---
layout: post
title: Java8 New Date and Time API
comments: true
---

## 변경사항 

자바 8에서는 신규 Date와 Time에 관한 API가 소개 되었다. 
과거 java.util.Date 와 java.util.Calendar 유틸은 정말 형편없었다. 

그럼 Java 8이전과 이후의 Date, Time관련 유틸리티가 어떻게 바뀌었는지 한번 살펴보자. 

### 기존 Java Date 유틸리티의 문제. 
과거 Java Date유틸리느는 비 일관성, 설계적인 결함 을 가지고 있었다.

1. Object 내용 자체가 변경이 된다. 
2. 이름규칙 Date 클래스이면서 시간까지 모두 커버
3. 1월은 데이트 객체 생성시 0에 해당한다. 
4. Date객체를 생성할때 년도 = 현재년도 - 1900 에 해당하는 오프셋을 .. (흠 매번 계산을 해야하다니)
5. thread unsafe한 DateTime Format

### 새롭게 바뀐점. 

1. 날짜 구조 
LocalDate + LocalTime + ZoneId
LocateDateTime (LocalDate + LocalTime)
ZonedDateTime  (LocalDate + LocalTime + ZoneId)
2. 사람을 위한 유틸리티와, 머신을 위한 유틸리티의 구분
3. immutable 한 객체 (메소드를 실행하면 새로운 객체가 생성되는 방식) = ThreadSafe한 구조
4. TemporalAdjuster를 이용하면 날짜에 대한 커스텀 기능을 이용할 수 있다. 
5. Thread Safe한 DateTimeFormat지원
6. TimeZone을 지원하여 Daylight Saving Time을 지원한다. 

## 사용방법 

LocalDateTest.java

{% highlight java %}
//  LocalDate생성
LocalDate date = LocalDate.of(2016, 9, 12);

//  현재 날짜를 생성한다
date = LocalDate.now();

System.out.println("-------------[ LocalDate Methods ]--------------");
int year = date.getYear();
System.out.println(String.format("int year = date.getYearI();  : [%s]", year));

Month month = date.getMonth();
System.out.println(String.format("Month month = date.getMonth();  : [%s]", month));

int day = date.getDayOfMonth();
System.out.println(String.format("int day = date.getDayOfMonth(); : [%s]", day));

DayOfWeek dow = date.getDayOfWeek();
System.out.println(String.format("DayOfWeek dow = date.getDayOfWeek(); : [%s]", dow));

int len = date.lengthOfMonth();
System.out.println(String.format("int len = date.lengthOfMonth(); : [%s]", len));

boolean leap = date.isLeapYear();
System.out.println(String.format("boolean leap = date.isLeapYear();: [%s]", leap));

System.out.println("-------------[ Using Temporal Fields ]--------------");
int yearByField = date.get(ChronoField.YEAR);
System.out.println(String.format("int yearByField = date.get(ChronoField.YEAR); : [%s]", yearByField));

int monthByField = date.get(ChronoField.MONTH_OF_YEAR);
System.out.println(String.format("int monthByField = date.get(ChronoField.MONTH_OF_YEAR); : [%s]", monthByField));

int dayByField = date.get(ChronoField.DAY_OF_MONTH);
System.out.println(String.format("int dayByField = date.get(ChronoField.DAY_OF_MONTH); : [%s]", dayByField));
{% endhighlight %} 

{% highlight java %}
-------------[ LocalDate Methods ]--------------
int year = date.getYearI();  : [2016]
Month month = date.getMonth();  : [SEPTEMBER]
int day = date.getDayOfMonth(); : [12]

DayOfWeek dow = date.getDayOfWeek(); : [MONDAY]
int len = date.lengthOfMonth(); : [30]
boolean leap = date.isLeapYear();: [true]

-------------[ Using Temporal Fields ]--------------
int yearByField = date.get(ChronoField.YEAR); : [2016]
int monthByField = date.get(ChronoField.MONTH_OF_YEAR); : [9]
int dayByField = date.get(ChronoField.DAY_OF_MONTH); : [12]
{% endhighlight %}

LocalTime.java

{% highlight java %}
LocalTime time = LocalTime.of(20, 30, 01);

int hour = time.getHour();
System.out.println(String.format("int hour = time.getHour(); : [%s]", hour));

int minute = time.getMinute();
System.out.println(String.format("int minute = time.getMinute(); : [%s]", minute));

int second = time.getSecond();
System.out.println(String.format("int second = time.getSecond(); : [%s]", second));
{% endhighlight %}

{% highlight java %}
int hour = time.getHour(); : [20]
int minute = time.getMinute(); : [30]
int second = time.getSecond(); : [1]
{% endhighlight %}

LocalDateTimeTest.java

{% highlight java %}
LocalDateTime dateTime1 = LocalDateTime.of(2014, Month.SEPTEMBER, 12, 20, 30, 01);

LocalDate date = LocalDate.now();
LocalTime time = LocalTime.now();
LocalDateTime dateTime2 = LocalDateTime.of(date, time);

LocalDateTime dateTime3 = date.atTime(20, 35, 30);

LocalDateTime dateTime4 = date.atTime(time);

LocalDate localDate = dateTime1.toLocalDate();
System.out.println(String.format("LocalDate localDate = dateTime1.toLocalDate(); : [%s]", localDate));

LocalTime localTime = dateTime1.toLocalTime();
System.out.println(String.format("LocalTime localTime = dateTime1.toLocalTime(); : [%s]", localTime));
{% endhighlight %}

{% highlight java %}
LocalDate localDate = dateTime1.toLocalDate(); : [2014-09-12]
LocalTime localTime = dateTime1.toLocalTime(); : [20:30:01]
{% endhighlight %}

머신을 위한 시간 처리방법 

Instant.ofEpochSecond(3);
Instant.ofEpochSecond(3, 0);
Instant.ofEpochSecond(2, 1_000_000_000);
Instant.ofEpochSecond(4, -1_000_000_000);

경과시간 알아내기 

Duration durationByTime = Duration.between(time1, time2);
Duration durationByDateTime = Duration.between(dateTime1, dateTime2);
Duration durationByInstant = Duration.between(instant1, instant2);

경과 날짜 및 월, 년 알아내기 

Period tenDays = Period.between(LocalDate.of(2016, 09, 02), LocalDate.of(2016.09.12));

{% highlight java %}
Duration threeMinutes = Duration.ofMinutes(3);
System.out.println(String.format("Duration threeMinutes = Duration.ofMinutes(3); : [%s]", threeMinutes));


Duration fourMinutes = Duration.of(4, ChronoUnit.MINUTES);
System.out.println(String.format("Duration fourMinutes = Duration.of(4, ChronoUnit.MINUTES); : [%s]", fourMinutes));

Period tenDays = Period.ofDays(10);
System.out.println(String.format("Period tenDays = Period.ofDays(10); : [%s]", tenDays));

Period threeWeeks = Period.ofWeeks(3);
System.out.println(String.format("Period threeWeeks = Period.ofWeeks(3); : [%s]", threeWeeks));

Period twoYearsSixMonthsOneDay = Period.of(2, 6, 1);
System.out.println(String.format("Period twoYearsSixMonthsOneDay = Period.of(2, 6, 1); : [%s]", twoYearsSixMonthsOneDay));
{% endhighlight %}

{% highlight java %}
Duration threeMinutes = Duration.ofMinutes(3); : [PT3M]
Duration fourMinutes = Duration.of(4, ChronoUnit.MINUTES); : [PT4M]
Period tenDays = Period.ofDays(10); : [P10D]
Period threeWeeks = Period.ofWeeks(3); : [P21D]
Period twoYearsSixMonthsOneDay = Period.of(2, 6, 1); : [P2Y6M1D]
{% endhighlight %}

날짜 변경 

{% highlight java %}
LocalDate date01 = LocalDate.of(2006, 06, 01);
2006-06-01

LocalDate date02 = date01.withYear(2016); 
2016-06-01

LocalDate date03 = date02.withDayOfMonth(12);
2016-06-12

LocalDate date04 = date03.with(ChronoField.MONTH_OF_YEAR, 09);
2016-09-12
{% endhighlight %}

날짜 연산 

{% highlight java %}
LocalDate date01 = LocalDate.of(2006, 06, 01);
2006-06-01

LocalDate date02 = date01.plusYears(10);
2016-06-01

LocalDate date03 = date02.plusMonth(3);
2016-09-01

LocalDate date04 = date03.plus(11, ChronoUnit.DAYS);
2016-09-12
{% endhighlight %}

TemporalAdjuster interface

{% highlight java %}
@FunctionalInterface
public interface TemporalAdjuster {
    Temporal adjustInto(Temporal temporal);
}
{% endhighlight %}

Temporal 객체를 새로운 Temporal객체로 변경하는 작업을 하도록 하는 인터페이스이다. 
이를 통해서 복잡한 날자 연산 처리를 구현할 수 있다. 

주말 배송을 하지 않을경우 배송일 처리용 TemporalAdjuster 구현체

{% highlight java %}
public class EstimateDeliverableDay implements TemporalAdjuster {
    @Override
    public Temporal adjustInto(Temporal temporal) {
        DayOfWeek dayOfWeek = DayOfWeek.of(temporal.get(ChronoField.DAY_OF_WEEK));

        int duration = 1;

        if (dayOfWeek == DayOfWeek.FRIDAY) duration = 3; // 월요일
        else if (dayOfWeek == DayOfWeek.SATURDAY
            || dayOfWeek == DayOfWeek.SUNDAY) duration = 2; // 화요일

        return temporal.plus(duration, ChronoUnit.DAYS);
    }
}
{% endhighlight %}

사용 

{% highlight java %}
EstimateDeliverableDay estmateDay = new EstimateDeliverableDay();
date = date.with(estmateDay);
{% endhighlight %}

날짜 포매팅하기. 

{% highlight java %}
LocalDate date = LocalDate.of(2016, 9, 12);

String isoDate = date.format(DateTimeFormatter.BASIC_ISO_DATE);
20160912

String isoLocalDate = date.format(DateTimeFormatter.ISO_LOCAL_ATE);
2016-09-12

DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy MM dd");
String formattedString = date.format(formatter);
LocalDate parsedDate = LocalDate.parse(formattedString, formatter);
2016 09 12

DateTimeFormatter koreanFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd", Locale.KOREAN);
LodalDate date02 = LocalDate.of(2016,9,12);
String formattedDateString = date02.format(koreanFormatter);
LocaleDate parsedDate02 = LocalDate.parse(formattedDateString, koreanFormatter);

{% endhighlight %}

날짜 포매팅 빌더 이용하기. 

{% highlight java %}
DateTimeFormatter koreanFormatter = new DateTimeFormatterBuilder()
        .appendText(ChronoField.DAY_OF_MONTH)
        .appendLiteral(".")
        .appendText(ChronoField.MONTH_OF_YEAR)
        .appendLiteral(" ")
        .appendText(ChronoField.YEAR)
        .parseCaseInsensitive()
        .toFormatter(Locale.KOREAN);

LocalDate date1 = LocalDate.of(2016, 9, 12);
System.out.println("Formatted Date : " + date1.format(koreanFormatter));

DateTimeFormatter koreanFormatter2 = new DateTimeFormatterBuilder()
        .appendText(ChronoField.YEAR)
        .appendLiteral("-")
        .appendText(ChronoField.MONTH_OF_YEAR)
        .appendLiteral("/")
        .appendText(ChronoField.DAY_OF_MONTH)
        .parseCaseInsensitive()
        .toFormatter(Locale.KOREAN);
System.out.println("Formatted Date2 : " + date1.format(koreanFormatter2));

Formatted Date : 12.9월 2016
Formatted Date2 : 2016-9월/12

{% endhighlight %}

타임존 이용하기. 

타임존은 DST(Daylight Saving Time)을 적용한 지역 시간을 위해 사용한다. 

{% highlight java %}
ZoneId koreanZone = ZoneId.of("Asia/Seoul");
ZoneId defaultZone = TimeZone.getDefault().toZoneId();

System.out.println("KoreanZone : " + koreanZone);
System.out.println("defaultZone : " + defaultZone);

LocalDate date = LocalDate.of(2016,  Month.SEPTEMBER, 12);
ZonedDateTime zoneTime = date.atStartOfDay(koreanZone);
System.out.println(String.format("LocalDate date = LocalDate.of(2016,  Month.SEPTEMBER, 12); [%s]", zoneTime));

LocalDateTime datetime = LocalDateTime.of(2016, Month.SEPTEMBER, 12, 23, 24);
ZonedDateTime zoneTime2 = datetime.atZone(koreanZone);
System.out.println(String.format("LocalDateTime datetime = LocalDateTime.of(2016, Month.SEPTEMBER, 12, 23, 24); [%s]", zoneTime2));

Instant instant = Instant.now();
ZonedDateTime zoneTime3 = instant.atZone(koreanZone);
System.out.println(String.format("Instant instant = Instant.now(); [%s]", zoneTime3));
{% endhighlight %}

{% highlight java %}
KoreanZone : Asia/Seoul
defaultZone : Asia/Seoul
LocalDate date = LocalDate.of(2016,  Month.SEPTEMBER, 12); [2016-09-12T00:00+09:00[Asia/Seoul]]
LocalDateTime datetime = LocalDateTime.of(2016, Month.SEPTEMBER, 12, 23, 24); [2016-09-12T23:24+09:00[Asia/Seoul]]
Instant instant = Instant.now(); [2016-09-12T23:17:43.652+09:00[Asia/Seoul]]

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

