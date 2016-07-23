---
title: Python3 socket programming
layout: post
subtitle: Python low level socket programming
---

## Python3 socket?
Python에서는 2가지 타입의 네트워크 접근방법을 제공한다.
하나는 low level의 소켓이고, 다른 하나는 higher-level의 접근으로 FTP나 HTTP등을 제공한다. 

## Socket이란?
소켓은 2개의 서로다른 머신에서 (동일머신도 가능) 상호 커뮤니케이션을 위한 채널을 말한다. 
소켓은 대표적으로 TCP와 UDP 를 제공한다. 

### 소켓 용어

|Term|Description|
|domain|프로토콜 패밀리로 이는 전송 매커니즘으로 사용한다. AF_INET, PF_INET, PF_UNIX, PF_X25등이 있다.|
|type|두 엔드포인트에서 서로 사용할 커뮤니케이션 타입이다. 연결지향의 SOCK_STREAM, 비연결지향인 SOCK_DGRAM이 있다.|
|protocol|일반적으로 zeor값이며 이는 도메인과 타입과 함께 다양한 프로토콜을 지정한다.|
|hostname|호스트네임은 네트워크 인터페이스를 구분짓는 값이다. |
|port|각 서버는 클라이언트의 요청을 기다리기 위해서 리슽하고 있는 프로그램을 의미한다. |

## Socket모듈 사용하기. 
파이선에서 소켓 모듈을 이용하기 위해서는 다음과 같은 구문을 이용한다. 
{% highlight python %}
s = socket.socket(socket_family, socket_type, protocol=0)
{% endhighlight %}

|파라미터|설명|
|socket_family|AF_UNIX, AF_INET등과 같이 도메인을 나타낸다.|
|socket_type|SOCK_STREAM(TCP), SOCK_DGRAM(UDP)가 올수 있다.|
|protocol|일반적으로 0을 지정한다.|

## 서버에서 사용하는 소켓 메소드
```s.bind()``` 는 주소를 바인드한다. (hostname, port)쌍으로 바인드된다. 

```s.listen()```는 TCP리스너를 스타트 하는 명령어이다. 

```s.accept()```는 TCP클라이언트가 접속하기를 기다리는 것이다. (blocking된다고한다.)

## 클라이언트에서 사용하는 소켓 메소드
```s.connect()```는 TCP서버에 접근을 수행하는 메소드이다. 

## 공용 메소드 
```s.recv()``` 는 TCP메시지를 수신받는다. 

```s.send()```는 TCP메시지를 전송한다. 

```s.recvfrom()```는 UDP메시지를 수신받는다. 

```s.sendto()```는 UDP메시지를 전송한다. 

```s.close()```는 소켓을 닫는다. 

```socket.gethostname()``` 호스트이름을 반환한다. 

## [서버소켓 프로그램](https://github.com/unclebae/Python3-tutorial/blob/master/19.network/simpleServer.py) 
{% highlight python %}

import socket

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host = socket.gethostname()
port = 9999

serversocket.bind((host, port))
serversocket.listen(5)

while True:
    clientsocket, addr = serversocket.accept()
    print("Got a connection from %s" % str(addr))

    msg='Thank you for connection' + "\r\n"
    clientsocket.send(msg.encode('ascii'))
    clientsocket.close()


{% endhighlight %}

## [클라이언트 소켓 프로그램](https://github.com/unclebae/Python3-tutorial/blob/master/19.network/simpleClient.py) 

{% highlight python %}

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
host = socket.gethostname()

port = 9999

s.connect((host, port))

msg = s.recv(1024)
s.close()

print(msg.decode('ascii'))
{% endhighlight %}

## 실행하기. 
{% highlight python %}
python simpleServer.py &
python simpleClient.py

{% endhighlight %}

