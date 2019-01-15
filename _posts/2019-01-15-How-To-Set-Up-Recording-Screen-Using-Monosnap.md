---
layout: post
title: How to set up recoding screen using Monosnap
comments: true
---
# How to set up recoding screen using Monosnap

벌써 유투브 동영상 생성이 화두가 된지 이미 오래입니다.. <br/>
어느덧 유투브를 통해서 강의도 듣고, 공연도 보고, 음악도 듣는 세상이 되었네요 <br/>
이런 동영상 제작을 위한 무료 툴이 있어 소개하고자 합니다.

## Monosnap 다운받기 

[Monosnap](https://monosnap.com/welcome) 에서 최신판 Monosnap 을 다운로드 받습니다. \
설치를 해보면 아래 이미지와 같은 아이콘이 나타납니다.\

![Monosnap Icon]({{site.url}}/images/Monosnap.png)

이제 더블클릭 해보자. 

상단 메뉴바에 다음과 같은 메뉴를 확인할 수 있다. 

![Monosnap Menu]({{site.url}}/images/Monosnap02.png)

## 이용방법 

* Capture Area: 화면 캡쳐를 수행하며, 지정된 크기의 화면 캡쳐가 가틍하다. 
* Capture Fullscreen: 전체 화면을 캡쳐한다. 
* Record Video: 비디오 녹활르 수행한다. 

우리는 여기서 Record Video 를 클릭할 것입니다.

![Monosnap Record]({{site.url}}/images/Monosnap03.png)

가운데 붉은 바탕의 Record 버튼을 클릭하면 실제 톡화가 진행이 됩니다.

우측 상단에 확장 모양을 선택하면 전체 화면 캡쳐도 가능합니다.

녹화 버튼을 한번더 클릭하면 녹화가 종료되고 아래와 같이 리플레이를 할 수 있습니다. 

![Monosnap Record]({{site.url}}/images/Monosnap04.png)

그런데 무언가 이상하다. !!!

사운드가 나오지 않는다. 아무리 이야기를 해도 영상만 캡쳐가 되었고, 오디오가 캡쳐되지 않았습니다. 

## 사운드 나오게 하기 

이는 사운드 입력장치 설정을 하지 않은 문제이며, 특히 Mojave 에서는 보안 이슈로 인해서 보안해제까지 해 주어야합니다.

### 사운드 입력 장치 다운받기 

[Soundflower](https://github.com/mattingalls/Soundflower/releases/tag/2.0b2)

에 가서 Soundflower-2.0b2.dmg 를 다운로드 받고 실행합니다.

![Monosnap Record]({{site.url}}/images/Sunflower01.png)

가 나오면 Soundflower.pkg 를 더블클릭해서 설치해줍니다. 

![Monosnap Record]({{site.url}}/images/Sunflower02.png)

무언가 안됩니다. 실패가 되었다고 나옵니다. 


### 권한풀어주기 

안되는 이유는 Mojave 에서 권한때문에 안됩니다. 

![Monosnap Record]({{site.url}}/images/Sunflower03.png)

"시스템환경설정" 을 선택하고 "보안 및 개인 정보 보호" 를 선택하고 

"일반" 탭 "허용..." 을 선택합니다. 그리고 MATT INGALL 등을 체크하고 확인합니다. 

그리고 다시 Sunflower.pkg 를 실행하여 다시 설치해줍니다. 

다시 정상으로 설치가 되었습니다. 

### 오디오 MIDI 설정해주기 

![Monosnap Record]({{site.url}}/images/Sunflower04.png)

를 열어줍니다. 

![Monosnap Record]({{site.url}}/images/Sunflower05.png)

![Monosnap Record]({{site.url}}/images/Sunflower06.png)

![Monosnap Record]({{site.url}}/images/Sunflower07.png)

위 순서대로 오디오 사용을 설정해줍니다. 

### Monosnap 와 Sunflower 연동해주기. 

다시 Monosnap 를 열고, Record Video 를 클릭합니다. 

![Monosnap Record]({{site.url}}/images/Sunflower08.png)

좌측상단의 "Setting" 버튼을 선택하고, Audio-Inputs 를 화면과 같이 설정해줍니다. 

이제 레코딩하고 마이크를 통해서 음성도 넣어봅니다. 

정상으로 수행됨을 확인할 수 있습니다. 



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


