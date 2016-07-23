---
layout: post
title: Python3 Thread
subtitle: python thread programming
---

## Thread and Process
쓰레드는 서로다른 프로그램(프로세스)들이 동시에 수행하는 것과 같은 효과를 낸다. 
그러나 다음과 같은 차이가 있다. 

멀티 쓰레드는 동일한 데이터 공간을 공유한다. 그러므로 스레드들 간의 커뮤니케이션이 프로세스보다 수월하다.
단, 공유자원으로 인한 부작용이 없도록 관리가 필요하다. 

멀티쓰레드는 경량의 프로세스라고 불린다. 이는 메모리 오버헤드가 작고, 자원들을 프로세스보다 더 작게 소비한다. 

## 스레드의 종류
```커널 스레드```는 오퍼레이팅 시스템의 영역이다. 
```유저 스레드```는 사용자 영역이며, 커널 영역에 구현되지 않는다. 

## 신규 스레드 생성하기. 

### 형식 
{% highlight python %}
_thread.start_new_thread( function, args[, kwargs] )
{% endhighlight %}

위 코드는 새로운 스레드를 생성한다. 이 메소드를 호출하는 즉시 자식 스레드를 생성하고, 시작한다. 그리고 이 스레드 메소드에 아규먼트를 전달하게 된다. 
함수는 스레드가 종료될때 반환하게 된다. 

```args```는 아규먼트의 튜플이며 아규먼트가 없다면 빈 튜플이 수행된다. 
```kwargs```는 선택적인 딕셔너리 자료형이다. 

## 예제 
{% highlight python %}

import _thread
import time

def print_time( threadName, delay ) :
    count = 0
    while count < 5:
        time.sleep(delay)
        count += 1
        print("%s: %s" % ( threadName, time.ctime(time.time()) ))
try:
    _thread.start_new_thread(print_time, ("Thread-1", 2, ) )
    _thread.start_new_thread(print_time, ("Thread-2", 4, ) )
except:
    print("Error: unable to start thread")

while 1:
    pass
{% endhighlight %}

thread 를 저수준으로 사용하면 매우 효과적이긴 하다. 그러나 새로운 스레드 모듈들과 비교등 다양한 제약점이 있다. 

## Threading Module
파이선 2.4부터 새로운 스레드 모듈들을 제공해 주고 있다. 이는 매우 강력하며, 고수준의 스레드를 지원해준다. 

threading 모듈은 스레드 모듈의 모든 메소드를 노출하며, 추가적인 기능도 제공한다. 

|기능|설명|
|threading.activeCount()|현재 active한 스레드 객체의 개수를 노출한다. |
|threading.currentThread()|현재 콜러에 의한 컨트롤 내에 있는 스레드 객체의 개수를 반환한다.|
|threading.enumerate()|현재 active한 모든 스레드 객체를 나열한다.|

추가적인 메소드로 threading 에 구현된 Thread의 클래스의 기능도 제공한다. 

|기능|설명|
|run()|스레드의 엔트리포인트이다. |
|start()|run메소드에 의해서 수행되는 메소드이다.|
|join([time])|스레드가 종료될때까지 대기한다. |
|isAlive()|스레드가 여전히 수행되고 있는지 검사한다.|
|getName()|스레드의 이름을 반환한다.|
|setName()|스레드의 이름을 지정한다.|

## Threading 모듈을 이용하여 스레드 생성하가. 
- 스레드 클래스의 하위 클래스를 정의한다. 
- __init__(self [,args]) 메소드를 추가한다. 
- run(self [, args])를 구현한다. 

일단 Thread의 서브 클래스를 생성하면 run()메소드를 호출함으로 해서 start()메소드를 수행할 수 있다.

### 예제 
{% highlight python %}

import threading
import time

exitFlag = 0

class myThread (threading.Thread) :
    def __init__(self, threadID, name, counter) :
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
	
    def run(self) :
        print("Starting " + self.name)
        print_time(self.name, self.counter, 5)
        print ("Exiting " + self.name)

def print_time(threadName, delay, counter) :
    while counter:
        if exitFlag:
            threadName.exit()
        time.sleep(delay)
        print("%s: %s" % (threadName, time.ctime(time.time())) )
        counter -=1

thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 2)

thread1.start()
thread2.start()
thread1.join()
thread2.join()

print("Exiting Main Thread")

{% endhighlight %}

## Synchronizing Threads
threading모듈은 단순한 라킹 메커니즘을 제공하고 있다. 이는 스레드를 synchronize 하도록 하여 구현한다. 

Lock()메소드를 호출하면 락이 생성된다. 이는 새로운 락을 반환한다. 

acquire(blocking)메소드는 스레드를 synchronously하게 수행할 수 있도록 해준다. 선택적인 블로킹 파라미터는 스레드가 락을 얻기 위해서 대기해야할지 지정한다. 

만약 blocking이 0으로 세팅되된다. 만약 락을 얻지 못하면 스레드는 즉시 0의 값을 반환한다. 만약 blocking이 1로 설정이 되면, 스레드는 블록되며, 락이 해제될때까지 대기한다. 

### 예제 
{% highlight pythom %}

import threading
import time

class myThread(threading.Thread):
    def __init__(self, threadID, name, counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter

    def run(self) :
        print("Starting " + self.name)
        threadLock.acquire()
        print_time(self.name, self.counter, 3)
        threadLock.release()

def print_time(threadName, delay, counter) :
    while counter:
        time.sleep(delay)
        print("%s: %s" % (threadName, time.ctime(time.time())) )
        counter -= 1

threadLock = threading.Lock()
threads=[]

thread1 = myThread(1, "Thread-1", 1)
thread2 = myThread(2, "Thread-2", 2)

thread1.start()
thread2.start()

threads.append(thread1)
threads.append(thread2)

for t in threads:
	t.join()
print("Exitig Main Thread")
{% endhighlight %}

## 멀티스레드된 우선순위 큐 
뮤 모듈은 새로운 큐 객체를 생성하고, 아이템의 특정 개수만큼 저장이 가능하다. 여기에는 다음 메소드들을 제공하여 큐를 컨트롤 할 수 있게 한다. 

|기능|설명|
|get()|큐로부터 아이템을 제거하고, 아이템을 반납한다. |
|put()|큐로부터 아이템을 입력한다.|
|qzise()|qzise()는 현재 큐내에서 실제하는 개수의 qzize()를 바환한다. |
|empty()|결과가 True이면 비어있다는 의미, False이면 비어있지 않음
|full()|True를 반환하면 큐가 차있다는 으미이고, False를 반환하면 그렇지 않은것이다.|

### 예제 
{% highlight python %}

import queue
import threading
import time

exitFlag = 0

class myThread(threading.Thread) :
    def __init__(self, threadID, name, q) :
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.q = q

    def run(self) :
        print("Starting " + self.name)
        process_data(self.name, self.q)
        print("Existing " + self.name)
	
threadList = ["Thread-1", "Thread-2", "Thread-3"]
nameList = ["One", "Two", "Three", "Four", "Five"]
queueLock = threading.Lock()
workQueue = queue.Queue(10)
	
def process_data(threadName, q) :
    while not exitFlag:
        queueLock.acquire()
        if not workQueue.empty() :
            data = q.get()
            queueLock.release()
            print ("%s processing %s" % (threadName, data) )
        else:
            queueLock.release()
        time.sleep(1)

threads = []
threadID = 1

for tName in threadList:
    thread = myThread(threadID, tName, workQueue)
    thread.start()
    threads.append(thread)
    threadID += 1

queueLock.acquire()
for word in nameList:
	workQueue.put(word)
queueLock.release()

while not workQueue.empty():
    pass

exitFlag = 1
for t in threads:
	t.join()

print("Exiting Main Trhead")
{% endhighlight %}
