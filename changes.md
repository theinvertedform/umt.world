---
title: Changelog
description: A chronological list of all additions to the website.
abstract: Here are all the pages on this website, listed in chronological order. It's a bit simplistic and not that helpful in its current form, but it's a complex undertaking so please bear with me. The goal is to condense items, and also to include page descriptions. The [commit log](https://github.com/theinvertedform/umt.world/activity) represents a partial history of changes to the website code.
toc: true
status: ongoing
date: 2022-09-11
tags:
  - projects
  - technology
  - archives
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
{% if post.collection == "diary" %}
  <li id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
  <a href="/{{ post.collection }}">Diary</a> &mdash; <a href="{{ post.url }}">{{ post.title }}</a> {% if post.description %} &mdash; <span class="post-description">{{ post.description }}</span> &mdash; {% endif %} Published on <time class="post-date" itemprop="datePublished">{{ post.date | date: "%A, %B %d, %Y" }}</time>{% if post.last_modified %}; last modified <time class="post-date" itemprop="dateModified">{{ post.last_modified | date: "%b %-d, %Y"}}</time>{% else %}.{% endif %}
  </li>
{% else %}
  <li id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
  <a href="/{{ post.collection }}">{{ post.collection | capitalize }}</a> &mdash; <a href="{{ post.url }}">{{ post.title }}</a> {% if post.description %} &mdash; <span class="post-description">{{ post.description }}</span> &mdash; {% endif %} Published on <time class="post-date" itemprop="datePublished">{{ post.date | date: "%A, %B %d, %Y" }}</time>{% if post.modified %}; last modified <time class="post-date" itemprop="dateModified">{{ post.modified | date: "%b %-d, %Y"}}</time>.{% else %}.{% endif %}
{% endif %}
</li>
{% endfor %}
  </ul>

{% assign month_num = month.name | date: '%m' %}
{% assign month_key = year.name | append: '-' | append: month_num %}
{% if site.data.git_stats[month_key] %}
<li class="git-summary">
  {{ site.data.git_stats[month_key].commit_count }} commits,
  +{{ site.data.git_stats[month_key].insertions }} lines,
  -{{ site.data.git_stats[month_key].deletions }} lines.
</li>
{% endif %}

</section>
{% endfor %}
</section>
{% endfor %}
