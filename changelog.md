---
title: Changelog
description: Rolling list of updates posted to umt.world.
---

{{ page.description }}

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear %}
<article>
<h1>{{ year.name }}</h1>
{% assign postsByMonth = year.items | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth %}
<section>
<h2>{{ month.name }}</h2>
<ul>
{% for post in month.items %}
<li>{% if post.category %}<a href="/categories#{{ post.category }}">{{ post.category }}</a> &mdash; {% endif %}<a href="{{ post.url }}">{{ post.title }}</a></li>
{% if post.modified %} Originally published {{ post.modified | date: "%b %-d, %Y"}}.{% endif %}
{% if post.abstract %}<aside class="abstract"><blockquote>{{ post.abstract }}</blockquote></aside>{% endif %}
{% endfor %}
</ul>
</section>
{% endfor %}
</article>
{% endfor %}

{% for post in site.posts %}
<article>
	{% assign author = site.data.authors[post.author] %}
	<a href="/categories#{{ post.category }}">{{ post.category }}</a> —
	<a href="{{ post.url }}">{{ post.title }}</a>
	Posted on <date>{{ post.date | date: "%b %-d, %Y" }}</date>{% if post.modified %} (last updated on {{ post.modified | date: "%b %-d, %Y" }}){% endif %}{% if post.origdate %}, originally published <date>{{ post.origdate | date: "%b %-d, %Y" }}</date>. {% else %}. {% endif %}
	{% if post.abstract %}<aside class="abstract"><blockquote>{{ post.abstract | strip_html }}</blockquote></aside>{% endif %}
</article>
{% endfor %}
