---
title: Blog
permalink: /blog
---
Rolling index of blog posts. For a list of contributors, [see here](/authors).

{% for post in site.posts %}
<article>
	{% assign author = site.data.authors[post.author] %}
	<a href="/categories#{{ post.category }}">{{ post.category | capitalize }}</a> —
	<a href="{{ post.url }}">{{ post.title }}</a>{% if author %},
	by <a href="/authors#{{ author.short_name | slugify }}">{{ author.name }}.</a>
	{% endif %}<br>
	Posted on <date>{{ post.date | date: "%b %-d, %Y" }}</date>{% if post.update %} (last updated on {{ post.update | date: "%b %-d, %Y" }}){% endif %}{% if post.origdate %}, originally published <date>{{ post.origdate | date: "%b %-d, %Y" }}</date>. {% else %}. {% endif %}
	<p><emph>{{ post.excerpt | strip_html }}</emph></p>
</article>
{% endfor %}
