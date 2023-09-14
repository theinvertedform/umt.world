---
title: Changelog
description: Rolling list of updates posted to umt.world.
layout: meta
abstract: Changes posted to the umt.world website. This is a complicated page that I am not close to figuring out. A known bug is that blog post.url doesn't work correctly. The concept of the page is loose, as well, but to make it at all worthwhile, it needs to include data on modifications to the source code. We also need to programatically set the categories. It's a mess.
toc: true
status: ongoing
---

{% assign postsByYear = site.documents | sort:"date" | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear reversed %}
<section id="{{ year.name }}">
<h1 id="{{ year.name }}"><a href="#{{ year.name }}">{{ year.name }}</a></h1>
{% assign postsByMonth = year.items | sort | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth reversed %}
<section id="{{ year.name }}-{{ month.name | date: '%m' }}">
<h2 id="{{ year.name }}-{{ month.name | date: '%m' }}"><a href="#{{ year.name }}-{{ month.name | date: '%m' }}">{{ month.name | date: '%B' }}</a></h2>
<ul>
{% for post in month.items reversed %}
<li class="blog-post" id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
{% if post.collection == "blog" %}<a href="/{{ post.collection }}">{{ post.collection | capitalize }}</a> &mdash; {% else %}<a href="/index#{{ post.collection }}">{{ post.collection | capitalize }}</a> &mdash; {% endif %}<a href="{{ post.url }}">{{ post.title }}</a> {% if post.description %}<em>{{ post.description }}</em>
{% if post.modified %} Originally published on {{ post.date | date: "%A, %B %d, %Y" }}; last modified {{ post.modified | date: "%b %-d, %Y"}}.
{% else %}{{ post.date | date: "%A, %B %d, %Y" }}. {{ post.content | number_of_words }} words
{% endif %}
{% endif %}
</li>
{% if post.abstract %}<aside class="abstract"><blockquote>{{ post.abstract }}</blockquote></aside>{% endif %}
{% endfor %}
</ul>
</section>
{% endfor %}
</section>
{% endfor %}
