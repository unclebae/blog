---
layout: post
title: Linux Sort 명령어
---

## Linux Sort 명령어 man page
{% highlight shell %}
이름
       sort - sort lines of text files

개요
       sort [OPTION]... [FILE]...

설명
    모든 FILE(s)의 통합된 결과를 소트하여 표준 출력으로 출력한다. 

    긴 옵션들의 필수 아규먼트는 짧은 인수에서도 필수이다. 
	옵션들은 다음과 같다. 
       -b, --ignore-leading-blanks
	      leading blank를 제거한다. 

       -d, --dictionary-order
	      오직 공백과 알파뉴메릭 문자만 고려한다. 

       -f, --ignore-case
             lower case를 대문자 케이스로 변환하여 검색한다. 즉, 대소문자를 고려하지 않는다. 

       -g, --general-numeric-sort
             일반적인 숫자 값에 따라 비교를 수행한다. 

       -i, --ignore-nonprinting

             오직 프린트 가능한 문자만을 비교하여 소트한다. 

       -M, --month-sort  
	      compare (unknown) < `JAN' < ... < `DEC'

       -n, --numeric-sort
             스트링의 숫자 값들만을 비교한다. 

       -r, --reverse
             역순으로 소트한다. 

       기타 옵션들:

       -c, --check
             input이 소트 되었는지 체크한다.; 소트는 하지 않는다. 

       -k, --key=POS1[,POS2]
             특정 POS1의 기준으로 시작하여 POS2에 끝낸다. (즉, 소트할 필드를 지정한다.)

       -m, --merge
             이밎 소트된 파일들을 머지한다.; 이후 소트는 하지 않는다. 

       -o, --output=FILE
             표준 출력 대신에 파일로 소트 결과를 반환한다. 

       -s, --stable
             가장 최근의 소트를 이용하는 기능을 정지하고, 안전하게 소트한다. 

       -S, --buffer-size=SIZE
             메인 메모리 버퍼를 위한 사이즈를 이용한다. 

       -t, --field-separator=SEP
             non-blank를 blank로 전이하는 것 대신에 SEP를 이용한다. 

       -T, --temporary-directory=DIR
             임시적으로 DIR를 이용한다. 이는 $TMPDIR혹은 /tmp를 이용하지 않는다. 복수개의 옵션들로 복수개의 디렉토리를 지정한다. 

       -u, --unique
             -c 옵션과 함께 제한된 정렬을 체크한다. -c가 없으면 오직 처음으로 같은 것만 출력한다.

       -z, --zero-terminated
             마지막 라인은 0바이트로 처리한다. 뉴라인이 아닌. 

       --help 
             도움말을 출력한다.

       --version
             버젼을 출력한다. 

       POS는 F[,C][OPTS], F는 필드 번호를 의마하고, C는 필드 내에 문자 위치를 의미한다. OPT는 하나 혹은 여러개의 단일문자로 정렬 옵션이다. 
       이것은 키를 위한 글로벌 정렬 옵션을 상속 받는다. 키가 주어지지 않은경우 키로 전체 라인이 사용된다. 

       SIZE는 

       SIZE  may be followed by the following multiplicative suffixes: % 1% of
       memory, b 1, K 1024 (default), and so on for M, G, T, P, E, Z, Y.

       FILE가 없거나 혹은 FILE가 -인경우 표준 입력을 받는다. 

       *** 주의 *** 로컬로 지정한 환경변수는 소트 정렬에 영향을 준다. LC_ALL=C는 전통적으로 소트를 위해서 native byte 값으로 정렬을 한다. 

AUTHOR
       Written by Mike Haertel and Paul Eggert.

이하생략 : 

{% endhighlight %}

## 샘플 예제 : 
### 기초데이터 : 
testFile
{% highlight linux %}
9 nine 아홉
3 three 세엣
2 two 두울
3 three 세엣
4 four 네엣
6 six 여섯
5 five 다섯
1 one 하나
7 seven 일곱
4 four 네엣
10 ten 열
5 five 다섯
8 eight 여덟
1 one 하나
{% endhighlight %}

### 기본정렬하기. 
sort testFile
{% highlight linux %}

1 one 하나
1 one 하나
10 ten 열
2 two 두울
3 three 세엣
3 three 세엣
4 four 네엣
4 four 네엣
5 five 다섯
5 five 다섯
6 six 여섯
7 seven 일곱
8 eight 여덟
9 nine 아홉
{% endhighlight %}

### 숫자 올바르게 정렬하기.
sort -n testFile
{% highlight linux %}

1 one 하나
1 one 하나
2 two 두울
3 three 세엣
3 three 세엣
4 four 네엣
4 four 네엣
5 five 다섯
5 five 다섯
6 six 여섯
7 seven 일곱
8 eight 여덟
9 nine 아홉
10 ten 열
{% endhighlight %}

### 역순 정렬하기. 
sort -rn testFile
{% highlight linux %}

10 ten 열
9 nine 아홉
8 eight 여덟
7 seven 일곱
6 six 여섯
5 five 다섯
5 five 다섯
4 four 네엣
4 four 네엣
3 three 세엣
3 three 세엣
2 two 두울
1 one 하나
1 one 하나
{% endhighlight %}

### 2번째 칼럼 정렬하기.
sort -k 2 testFile
{% highlight linux %}
8 eight 여덟
5 five 다섯
5 five 다섯
4 four 네엣
4 four 네엣
9 nine 아홉
1 one 하나
1 one 하나
7 seven 일곱
6 six 여섯
10 ten 열
3 three 세엣
3 three 세엣
2 two 두울
{% endhighlight %}

### 2번째 칼럼 역순 정렬하기.
sort -r -k 2  testFile
{% highlight linux %}

2 two 두울
3 three 세엣
3 three 세엣
10 ten 열
6 six 여섯
7 seven 일곱
1 one 하나
1 one 하나
9 nine 아홉
4 four 네엣
4 four 네엣
5 five 다섯
5 five 다섯
8 eight 여덟
{% endhighlight %}

### 중복제거하여 정렬하기. 
sort -u -n testFile
{% highlight linux %}

1 one 하나
2 two 두울
3 three 세엣
4 four 네엣
5 five 다섯
6 six 여섯
7 seven 일곱
8 eight 여덟
9 nine 아홉
10 ten 열
{% endhighlight %}

### 중복 제거하여 2번째 칼럼 역순 정렬하기. 
sort -u -k 2 testFile
{% highlight linux %}

8 eight 여덟
5 five 다섯
4 four 네엣
9 nine 아홉
1 one 하나
7 seven 일곱
6 six 여섯
10 ten 열
3 three 세엣
2 two 두울
{% endhighlight %}


