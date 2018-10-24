---
layout: post
title: ML - Introduction to Natural Language Processing
comments: true
---
# ML - Introduction to Natural Language Processing

from : [Introduction to Natural Language Processing](https://www.commonlounge.com/discussion/ed0ac1f06b5440ccb769e3bf5128ed4e?ref=digest&user=d9ba9a3763194b7397dd6a091dcc51b3)

Natural Language Processing(NLP) 는 인간의 언어를 이해하는 것을 말한다. <br/>
이는 오래전부터 추구하던 것이었으며 앨런 튜링이나 노암 촘스키도 이를 해결하기 위해 노력했다. 

## What is Natural Language?

자연어라는 것은 인간간의 커뮤니케이션을 위한 언어를 말한다. <br/>
이것은 이메일, 아티클, 텍스트, 블로그, 뉴스, 말하기 등에서 사용된다. <br/>
세상에는 trillions(조) 단위의 자연 언어들이 있다. <br/>

NLP 는 Natural Language의 계층적 구조 모델을 종종 이야기한다. 이는 단어로 부터 문자, 문장으로부터 단어, 구문으로부터 문장, 단락으로부터 구문, 문서로부터 단락 등의 구조적인 형태를 띈다.

## Application of NLP

공통적인 NLP 어플리케이션 이용 : 

- Document Classification : 문서화된 도큐먼트를 복수개의 카테고리로 분류 한다. 뉴스아티클을 분류하거나, 스포츠, 정치, 사업, 기술, 등등을 분류하거나, 회사에서 인보이스를 분리, 구매행위를 수행하는 곳에 이용된다. 

- Document Clustering : 유사한 구문을 찾고, 그룹으로 부터 분리하는 작업을 한다. 문서들은 동일한 그룹의 부분으로 가깝게 연관되어 있다. 예를 들어 유사한 질문을 구분한다거나, 기존 의학연구 내용을 찾아내는 등의 작업을 말한다. 

- Sentiment Analysis : 감정 분석은 부정적인 감정에서 자연적으로 긍정적인 감정까지 분석하는 것을 이야기한다. 이것은 보통 고객의 의견을 분석하는데 많이 이용한다. 

- Document Summarization : 문서에서 가장 중심이 되는 중요 의미를 뽑아내는 것을 이야기한다. 예를 들어 3000 단어의 문서를 200개의 단어로 정리하는 것을 말한다. 이는 사람이 글을 읽는데 드는 노력을 줄여준다. 

- Named Entity Recognition : entity extraction 으로 알려져 있으며, 이름지어진 엔터티를 구분하고, 인간, 조직, 위치 등과 같이 카테고리 하는 것을 말한다. 이것은 주식 투자자들에 의해서 사용될 수 있으며 그들이 투자한 회사에 대한 뉴스들을 분류해낸다거나 혹은 관심이 있는 스포츠를 찾아내는 것을 찾는다. 

- Question Answering : 인공지능 시스템으로 질문에 대한 응답을 하도록 하는 시스템이다. 이러한 시스템은 질문자의 지식 기반을 이용하게 된다. 이는 많은 인공지능 대화나 어시스턴스 솔류션 (아마존 알렉사)와 같은 곳에 이용된다.

- Machine Translation : 이는 하나의 언어에서 다른 언어로 번역하는 것을 말한다. 구글 사이트에서 구글 번역과 같은 시스템이다. 

## Components of NLP

NLP에 대한 처리는 2가지 메인 컴포넌트가 있다. 이는 자연어의 이해, 자연어의 생성 2가지로 구분된다. 

### Natural Language Understanding(NLU)

NLU 는 텍스트의 의미나 의도를 이해하는 것을 말한다. NLU는 다음과 같은 요구사항이 있다. 

* Morphological Analysis : 각각 단어의 구조를 분석하는 것이다. 형태소는 의미의 최소화 단위를 말하며 예를 들어 단어 care, cares, caring, careless, careful, uncaring 은 서로 다른 형태이지만 하나의 단어에서 나온 것이다. 이는 care 에서 뻗어져 나온 것이다. <br/>
또한 단어의 구조를 보면 un- 은 uncaring 으로, -less 는 careless 에 붙어서 사용된다. 

* Syntactic Analysis : parsing 으로 불리며 문장내에서 문법적으로 단어를 분석하는 것을 말한다. 이는 마이크로소프트 워드, 구글독, 등에서 문법 오류가 나면 하이라이트 되는 것을 볼 수 있다. 

* Semantic Analysis : 형태소와 문장 이해를 위한 문법을 이해하는 것이나, 텍스트나 전체 문장의 의도를 이해하는 것을 말한다. "I went to the market in my shorts" vs "I went to the market in the city", 이 두 용어는 2개의 문법적 구조는 동일하다. 그러나 의미는 다르다. <br/
"in my shorts" 에서는 I가 중요 포인트이고, "in the city" 는 market 의 의미이다. 

* Discourse Analysis : 이는 NLU 에서 더욱 어드벤스드한 영역이며, 문법 과 의미를 더 긴 텍스트를 인식하는 것을 의미한다. 전체 문서를 이해하거나, 구문 전체를 이해하는 것을 의미한다. 

### Natural Language Generation(NLG)

하나의 영역이 자연어를 이해하는 것이라면 NLG는 자연어를 이용하여 응답하거나, 텍스트를 생산해 내는 것을 말한다. 최근 어플리케이션들은 챗봇이나, 알렉사, 시리와 같은 기술을 탑재하고 있다. <br/>
일반적으로 NLG 시스템들은 NLU보다 더 복작하다. 

* Content Determination : 우리가 전달하려고 하는것이 어떤것인지 정의한다. 여기에는 사전에 빌트된 스키마 혹은 특정 내용의 템플릿이 있으며, 지식기반의 룰과 패턴 검출이나 템플릿 예측 등이 있다. <br/>
예를 들어 구글 어시스턴스는 사람의 나이를 물어보면 "{person_name} is {age} years old. {He/She} was born on {date}." 라는 템플릿으로 변환처리된다. 

* Planning / Micro-planning : 은 2개 이상의 서로다른 문장을 엮어서 하나의 축약된 문장을 만들어 내는 작업이다. 예를 들어 "Larry is feeling sleepy.", "Larry is drinking coffee", "Coffee is hot" 이라고 한다면 더 좋은 축약된 문장은 "Since Larry is sleepy, he is drinking hot coffee." 로 변환된다. 

* Deep Learning : 머신러닝의 서브 영역이며, 최근 가장 성공적인 분야중에 하나이다. 이는 언어 생성, 번역, QA 등에 활용되고 있다. 

### Challenges in NLP

자연어 처리에는 많은 도전이 있으며 아래 내용들이 있다. 

* Assumed knowledge / common sense : 가장 큰 도전과자는 언제든지 우리가 커뮤니케이션을 해야하는 것이다. 우리는 리더가 가지고 있는 지식에 대해서 가정을 해야한다. <br/>
이러한 지식은 인간에 대한 가장 기본적인 것이며, 이러한 지식과 같은 것은 머신이 접근할 수 없는 영역이다. 우리가 "Fox jumped over the fence" 와 "Fox jumped over the building" 그리고 "Fox jumped over the leaf", 라고 한다면 처음 것이 가장 적합할 것이다. <br/>
두번째 문장은 비현실 적이고, 세번째는 의미없는 무장과 같다. 

* Volume : 거대한 양의 텍스트가 온라인에 존재한다. 그리고 문서들은 특정 조직에 존재한다. 거대한 양의 데이터는 머신러닝에 매우 큰 보너스이지만, 효과적인 계산이 필요하다. 

* Variation : 자연어는 단어가 끈엄없이 넓은 용어로 사용된다. 다양한 방언들이 존재하며 이들은 변화한다. 이러한 것들을 공동화 하거나, 표준화 하는 것이 매우 어렵다. 

* Complex : 매우 복잡한 문장을 서로 연결하여 의미를 만드는 것은 어려운 알고리즘이다. 예를 들어 "run", "set" 등과 같은 단어는 의미에 따라 매우 다른 정의로 이용이 된다. 예를 들어 "having" 은 "Adam is having coffee", "Adam is having a good time" 은 서로 다른 의미로 쓰여진다. 

* Grammar is vague : 가끔 문법 룰들은 잘 정의 되어 있지 않다. 그리고 문법의 예외적인 룰이 잇다. 문법은 의미에서 매우 모호할 수 있다. 

* Expression : 감정, 빈정댐과 같은 것을 문장에서 분석하는 것은 매우 어렵고 이해하기 어렵다. 

### Approaches to NLP

넓게 3가지 접근 방법이 있다. 

* Computational Linguistics : 수학 혹은 과학을 언어에 적용한다. 이 접근은 전통적인 어어학으로 다양한 어어 룰을 나눈다. NLP알고리즘은 오토마타, 통계 그리고 다어의 상호 발생 통계 등을 분석한다. Noam Chomsky에 의해서 대부분의 이론이 나왔다.

* Machine Learning : 머신러닝에서는 텍스트 데이터를 수치 벡터로 변환한다. 벡터들은 단어의 빈도 혹은 상호 연결되어서 나타나는 빈도들을 나타낸다. <br/>
텍스트가 벡터로 변환되면 Naive Bayes', Support Vector Machine 등을 이용하여 수행된다. 이때 텍스트 데이터를 분류한다.<br/> 
머신러닝 메소드는 지금 매우 잘 알려져 있는 영역이 되었다. 이제는 거대한 양의 텍스트가 이제 정확한 트레이닝 모델이 적용되어 있다.

* Deep Learning : 딥러닝은 머신러닝의 부분 필드이며, 더욱 복잡한, 부분과 유연한 모델을 적용할 수 있는 장점이 있따. 이러한 방법은 최신 기술을 이용하여 번역, 답변 등에 이용된다. <br/>
처리 성능 향상 그리고 많은 양의 텍스트 데이터를 딥 뉴럴 네트워크에 적용하고, 높은 정확도를 얻을 수 있다. 

## Conclusion

지금까지 사펴본 것과 같이 NLP에는 다양한 기술, 도전해야할 과제등이 있음을 알게 되었다. 


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


