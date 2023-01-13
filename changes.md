---
title: Changelog
description: Rolling list of updates posted to umt.world.
layout: meta
abstract: Changes posted to the umt.world website. This is a complicated page that I am not close to figuring out. A known bug is that blog post.url doesn't work correctly. The concept of the page is loose, as well, but to make it at all worthwhile, it needs to include data on modifications to the source code. We also need to programatically set the categories. It's a mess.
toc: true
status: ongoing
---

{% assign postsByYear = site.documents | sort | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear reversed %}
<h1>{{ year.name }}</h1>
{% assign postsByMonth = year.items | sort | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth reversed %}
<h2>{{ month.name }}</h2>
<ul>
{% for post in month.items reversed %}
<li>{% if post.collection %}<a href="/{{ post.collection }}">{{ post.collection | capitalize }}</a> &mdash; {% endif %}<a href="{{ post.url  }}">{{ post.title }}</a>{{ post.content | number_of_words }}</li>
{% if post.modified %} Originally published on {{ post.date | date: "%b %-d, %Y" }}; last modified {{ post.modified | date: "%b %-d, %Y"}}.{% endif %}
{% if post.abstract %}<aside class="abstract"><blockquote>{{ post.abstract }}</blockquote></aside>{% endif %}
{% endfor %}
</ul>
{% endfor %}
{% endfor %}
