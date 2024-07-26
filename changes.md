---
title: Changelog
description: Rolling list of updates posted to umt.world.
abstract: Changes posted to the umt.world website. This is a complicated page that I hope to one day be much more useful in terms of keeping track of my productive output. I am not close to figuring it out. I would like it to even include a summary of updates to the website's code, design, features.
toc: true
status: ongoing
---

{% assign postsByYear = site.documents | sort:"date" | group_by_exp:"post", "post.date | date: '%Y'" %}

{% for year in postsByYear reversed %}
<section id="{{ year.name }}" class="level1">
  <h1 class="heading" id="{{ year.name }}">
  <a href="#{{ year.name }}">{{ year.name }}</a>
  </h1>

{% assign postsByMonth = year.items | sort:"date" | group_by_exp:"post", "post.date | date: '%B'" %}

{% for month in postsByMonth reversed %}
<section id="{{ year.name }}-{{ month.name | date: '%m' }}" class="level2">
  <h2 class="heading" id="{{ year.name }}-{{ month.name | date: '%m' }}">
  <a href="#{{ year.name }}-{{ month.name | date: '%m' }}">{{ month.name | date: '%B' }}</a> </h2>

  <ul>
{% for post in month.items reversed %}
{% if post.collection == "blog" %}
  <li id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
  <a href="/{{ post.collection }}">Diary</a> &mdash; <a href="{{ post.url }}">{{ post.title }}</a> {% if post.description %} &mdash; <span class="post-description">{{ post.description }}</span> &mdash; {% endif %} Published on <time class="post-date" itemprop="datePublished">{{ post.date | date: "%A, %B %d, %Y" }}</time>{% if post.last_modified %}; last modified <time class="post-date" itemprop="dateModified">{{ post.last_modified | date: "%b %-d, %Y"}}</time>{% else %}.{% endif %}
  </li>
{% else %}
  <li id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
  <a href="/{{ post.collection }}">{{ post.collection | capitalize }}</a> &mdash; <a href="{{ post.url }}">{{ post.title }}</a> {% if post.description %} &mdash; <span class="post-description">{{ post.description }}</span> &mdash; {% endif %} Published on <time class="post-date" itemprop="datePublished">{{ post.date | date: "%A, %B %d, %Y" }}</time>{% if post.modified %}; last modified <time class="post-date" itemprop="dateModified">{{ post.modified | date: "%b %-d, %Y"}}</time>.{% else %}.{% endif %}
{% endif %}
</li>
{% if post.abstract %}<aside class="abstract"><blockquote>{{ post.abstract }}</blockquote></aside>{% endif %}
{% endfor %}
  </ul>
</section>
{% endfor %}
</section>
{% endfor %}
