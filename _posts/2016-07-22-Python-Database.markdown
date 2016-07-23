---
layout: post
title: Python with Mysql
---

# 파이선에서 Mysql연동하기. 
## PyMySQL 설치하기
{% highlight python %}
# python3 version
pip3 intall pymysql
{% endhighlight %}

## Example 작성해보기. 
{% highlight python %}
#!/usr/bin/python3
import pymysql

# Open database connection
db = pymysql.connect("localhost", "testuser", "test123", "TESTDB")

# prepare a cursor object using cursor() method
cursor = db.cursor()

# execute SQL query using execute() method.
cursor.execute("SELECT VERSION()")

# Fetch a single row using fetchone() method.
data = cursor.getchone()

print ("Database version: %s " % data)

# disconnect from server
db.close()
{% endhighlight %}

해당 내역을 실행하면 다음과 같은 결과를 볼 수 있다. 
{% highlight python %}
Database version : 5.5.20-log
{% endhighlight %}

## 테이블 생성하기.
{% highlight python %}
import pymysql

db = pymysql.connect("localhost", "kido", "1212", "boards")

cursor = db.cursor()
cursor.execute("DROP TABLE IF EXISTS BOARD")

SQL = """
CREATE TABLE board (
    id BIGINT(10) NOT NULL AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
	content VARCHAR(4000) NULL,
	author VARCHAR(45) NULL,
	createAt TIMESTAMP NOT NULL DEFAULT now(),
	modifyAt TIMESTAMP NULL,
	PRIMARY KEY (id));
"""
cursor.execute(SQL)

db.close()

{% endhighlight %}


## 입력하기. 
{% highlight python %}

import pymysql

db = pymysql.connect("localhost", "kido", "1212", "boards")

cursor = db.cursor()
sql = """
    INSERT INTO BOARD (TITLE, CONTENT, AUTHOR) 
	VALUES ('TEST post', 'Hello this is test post... I Like This post', 'kido')
"""

try :
	cursor.execute(sql)
	db.commit()
except:
	db.rollback()

db.close()
{% endhighlight %}

## 동적 인서트 쿼리 수행하기. 
{% highlight python %}

import pymysql

title=input("Enter the Title ('title') :")
content=input("Enter the Contents ('content bla~ bla~') :")
author=input("Enter the author ('john') :")

db = pymysql.connect("localhost", "kido", "1212", "boards")

cursor = db.cursor()

sql = "INSERT INTO BOARD (TITLE, CONTENT, AUTHOR) \
    VALUES ('%s', '%s', '%s')" % \
	(title, content, author)

try:
	cursor.execute(sql)
	db.commit()
except:
	db.rollback()
db.close()

{% endhighlight %}

## 실행해보기 
{% highlight python %}
> py dynamicInsertBoard.py
Enter the Title ('title') :'title'
Enter the Contents ('content bla~ bla~') :'bla~ bla~'
Enter the author ('john') :'peter'
{% endhighlight %}

