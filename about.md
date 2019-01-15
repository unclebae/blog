---
layout: page
title: About me.
permalink: /about/
---
![MyCaricature]({{site.url}}/img/KIDO.jpg)

Hello my name is Kido. 
My nick is Unclebae. 

I want to be a guru like Uncle Bob.

My job is Computer Programmer. So. I interested in computer program.

My Interest is 
<ul>
{% for interest in site.data.profiles.profile.interest %}
  <li>
    <a href="{{interest.url}}">
      {{interest.stub}}
	</a>
  </li>
{% endfor %}
</ul>

If you want to contact to me or advise me.
Send email to [My_Email](mailTo:{{site.data.profiles.profile.contact.email}})
My Blog [Unclebae blog]({{site.data.profiles.profile.contact.blog}})
