---
layout: post
title: Python with Mysql
---

[샘플](https://github.com/unclebae/Python3-tutorial/tree/master)
[myslq python](https://dev.mysql.com/doc/connector-python/en/connector-python-api-mysqlcursor-fetchone.html)

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


## 단건 데이터 불러오기
{% highlight python %}

import pymysql

boardId = int(input('Please enter board id :'))

db = pymysql.connect('localhost', 'kido', '1212', 'boards')

cursor = db.cursor()
sql = "SELECT * FROM BOARD \
	WHERE ID = '%d'" % (boardId)
#print (sql)
try :
    cursor.execute(sql)
    result = cursor.fetchone()
    #print (result)

    if (result is not None):
		print ("Fetched Data : boardId=[%d], title=[%s], content=[%s], author=[%s], createAt=[%s], modifyAt=[%s]" % \
				(result[0], result[1], result[2], result[3], result[4], result[5]))
    else:
        print ('There is no data')
except:
    print("Error: unable to fetch data")

db.close()
{% endhighlight %}

## 전체 데이터 불러오기 
{% highlight python %}

import pymysql

db = pymysql.connect('localhost', 'kido', '1212', 'boards')

cursor = db.cursor()
sql = "SELECT * FROM BOARD"

#print (sql)
try :
    cursor.execute(sql)
    results = cursor.fetchall()
    #print (results)

    for result in results:
		print ("Fetched Data : boardId=[%d], title=[%s], content=[%s], author=[%s], createAt=[%s], modifyAt=[%s]" % \
				(result[0], result[1], result[2], result[3], result[4], result[5]))
    else:
        print ('no more datas')
except:
    print("Error: unable to fetch data")

db.close()
{% endhighlight %}

## 데이터 변경하기.

{% highlight python %}

import pymysql
import random

db = pymysql.connect('localhost', 'kido', '1212', 'boards')
cursor = db.cursor()

sql = """
    UPDATE BOARD SET content = '%s' WHERE id = 1 """ % (str(random.random()) + " are generaged.")

try:
    cursor.execute(sql)
    db.commit()
except:
    db.rollback()

sql2 = """
    SELECT * FROM BOARD WHERE id = 1"""

try:
    cursor.execute(sql2)
    rows = cursor.fetchone()
    print(rows)
except:
	print("Error select modified data")


db.close()

{% endhighlight %}

## 데이터 삭제하기...

{% highlight python %}

import pymysql
import sys

boardId = int(input('enter board id if you want if you don''t want to delete enter the -1 : '))

if (boardId == -1):
    print('exit')
    sys.exit()

db = pymysql.connect('localhost', 'kido', '1212', 'boards')

cursor = db.cursor()

sql = """
    DELETE FROM BOARD WHERE id = '%d'""" % boardId

try:
	cursor.execute(sql)
	db.commit()
	print ('complete deleting board about id [%d]' % boardId)
except:
	db.rollback()

db.close()
{% endhighlight %}


