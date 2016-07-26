---
layout: page
title: Python Data Analysis 01_install
---

## 파이선에서 제공하는 데이터 분석 도구

|도구|설명|
|[NumPy](http://www.numpy.org/)|파이선의 기초가 되는 라이브러리이며, 수치 배열과 함수를 제공한다. |
|[SciPy](http://docs.scipy.org/doc/)|과학을 위한 파이선 라이브러리이며, 이는 NumPy와 중첩되는 기능을 가지고 있다. NumPy와 SciPy는 동일한 계보를 가지고 있다. 둘은 분리되어 개발 되고 있다. |
|[matplotlib](http://matplotlib.org/)|NumPy를 기반으로 만들어진 플로팅 라이브러리이다.|
|[IPython](https://ipython.org/)|대화형 컴퓨팅을 위한 아키텍쳐를 제공한다. |

## 파이선 데이터 분석 도구 설치 
기본적으로 파이선은 MacOS를 기준으로 설치할 것이다. 

- 파이선 설치 (버젼 2.7 권장, 이후에는 3 사용할 것을 권장함)
- 파이썬 다운로드 : [다운로드](https://www.python.org/downloads/)

### homebrew설치. 
```/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"```

### Python 설치.
```brew install python --framework --universal```

### pip 설치. 
```easy_install pip```

### virtualenv 설치
virtualenv는 고립된 Python 환경을 만들어 주는 역할을 한다. 이는 패키지의 셋이나, 의존성을 소유하게 된다. 
이는 테스팅을 용이하게하고, 파키지 요구사항을 관리하는 책임을 가진다. 

```pip install virtualenv```

```pip install virtualevnwrapper```

```source /usr/local/share/python/virtualenvwrapper.sh``` 로 스크립트를 로드한다. 

``` mkvirtualenv  test1```은 가상 환경을 만들어 주는 역할을 하며 해당 디렉토리에 숨은 파일인 ~/.virtualenv를 만든다. 

``` rmvirtualenv test1```은 가상환경을 제거한다. 

### NumPy 설치하기. 
현재 버젼에 맞는 NumPy를 설치하기 위해서 다음을 입력하자. 

```pip install numpy``` 
### SciPy 설치하기. 

```pip install scipy``` 

### matplotlilb 설치하기. 

```pip install matplotlib```

### IPython 설치하기. 

```pip install ipython```

IPython 설치이후에 qtconsole를 설치하면 출력 결과를 라인으로 디스플레이 할 수 있다.

```brew install pyqt```
이를 설치하고 나면 brew는 .bash_profile 환경 변수 파일에 pythonpath를 다음과 같이 추가하게 된다. 

```export PYTHONPATH=/usr/local/lib/python:$PYTHONPATH

이제 iPython을 실행할때 qtconsole를 다음과 같이 실행할 수 있다. 

```ipython qtconsole --pylab=inline``` 

## NumPy Array란?
- NumPy Array는 Python의 list 연산보다 더 성능이 우수하다. 
- 수치 연산을 위해 만들어진 특수한 객체이다. 
- NumPy를 이용하면 더 적은 for 루프를 이용하여 각종 연산을 쉽게 할 수 있다. 
- 벡터를 기반으로 만들어져 있다. 

### NumPy 단순 예제 
2개의 숫자 벡터를 만들고자 한다. 

하나는 a라는 변수에 들어 있으며 0 ~ n까지의 정수형의 스퀘어 값을 가진다. 만약 n이 3이라면 내부 값은 각각의 스퀘어 값으로 0, 1, 4가 들어간다. 

다른하나는 b라는 변수에 들어 있으며 0 ~ n까지의 정슈형의 큐브 값을 가진다. 만약 n이 3이라면 내부 값은 각각의 큐브 값으로 0, 1, 8이 들어간다.  

이런 처리를 NumPy를 이용하면 매우 쉽게 처리할 수 있다. 

#### Sample Codes
{% highlight python %}

# -*- coding: utf-8 -*-

import sys
from datetime import datetime
import numpy as np

"""
    이 프로그램은 파이선 방식으로 벡터를 추가하는 예제를 보여준다. 
	이 프로그램은 다음과 같이 실행한다. 
	python vectorTest.py n

	n 값은 정수형으로 벡터의 총 길이를 나타낸다. 

	첫번째 벡터는 0 에서 n까지 스퀘어 값을 저장한다. 
	두번재 벡터는 0 에서 n까지 큐브 값을 저장한다. 

	이 프로그램은 마지막으로 2개의 엘리먼트들의 합을 구하는 것으로 이 시간을 기록하여 출력한다. 
"""

def numpysum(n) :
	a = np.arange(n) ** 2
	b = np.arange(n) ** 3
	c = a + b

	return c

def pythonsum(n):
	a = list(range(n))
	b = list(range(n))
	c = []

	for i in list(range(n)):
		a[i] = i ** 2
		b[i] = i ** 3
		c.append(a[i] + b[i])

	return c

size = int(sys.argv[1])

start = datetime.now()
c = pythonsum(size)
end = datetime.now()

print ("The last 2 elements of the sum", c[-2:])
print ("PythonSum elasped time in microseconds", (end-start).microseconds)

start = datetime.now()
c = numpysum(size)
end = datetime.now()

print ("The last 2 elements of the sum", c[-2:])
print ("PythonSum elasped time in microseconds", (end-start).microseconds)
{% endhighlight %}

#### 실행하기. 
python vectorTest.py 1000
{% highlight shell %}
('The last 2 elements of the sum', [995007996, 998001000])
('PythonSum elasped time in microseconds', 409)
('The last 2 elements of the sum', array([995007996, 998001000]))
('PythonSum elasped time in microseconds', 86)
{% endhighlight %}

상기 예제와 같이 numpy를 이용하는 것이 python을 이용한 단순 list처리보다 더 성능상의 이점이 있다. 

