---
layout: post
title: Python with Mysql
---

# 파이선에서 Mysql연동하기. 
## PyMySQL 설치하기
{% highlight python %}
pip install PyMySQL
{% endhighlight %}

## Example 작성해보기. 
{% highlight python %}
#!/usr/bin/python3
import PyMySQL

# Open database connection
db = PyMySQL.connect("localhost", "testuser", "test123", "TESTDB")

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
