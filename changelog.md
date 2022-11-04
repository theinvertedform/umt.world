---
title: Changelog
description: Rolling list of updates posted to umt.world.
layout: meta
abstract: Changes posted to the umt.world website.
toc: true
---

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear %}
<h1>{{ year.name }}</h1>
{% assign postsByMonth = year.items | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth %}
<h2>{{ month.name }}</h2>
<ul>
{% for post in month.items %}
<li>{% if post.category %}<a href="/categories#{{ post.category }}">{{ post.category }}</a> &mdash; {% endif %}<a href="{{ post.url }}">{{ post.title }}</a></li>
{% if post.modified %} Originally published {{ post.modified | date: "%b %-d, %Y"}}.{% endif %}
{% if post.abstract %}<aside class="abstract"><blockquote>{{ post.abstract }}</blockquote></aside>{% endif %}
{% endfor %}
</ul>
{% endfor %}
{% endfor %}
