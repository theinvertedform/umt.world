---
title: News
description: "[Sign up to receive the umt.world newsletter in your inbox.](https://umtworld.substack.com)"
abstract: Look at a prolific writer like Henry James, George Eliot, or Thomas Mann, and you will find that oftentimes their unpublished writing is as large as their published corpus. Much of the concept of umt.world as a unique literary form relates to notions of (self-)publishing. Additionally---all of my writing, for better or for worse, is part of my oeuvre. The newsletter, then, collects snippets from my Diary, from my camera, from the websites that I post reviews and other writings. It also represents a direct link between me and you.
toc:  true
date: 2025-01-31
published: false
---

{% assign postsByYear = site.newsletter | sort:"date" | group_by_exp:"post", "post.date | date: '%Y'" %}

{% for year in postsByYear reversed %}
<section id="{{ year.name }}" class="level1">
  <h1 class="heading" id="{{ year.name }}">
  <a href="#{{ year.name }}">{{ year.name }}</a>
  </h1>

{% assign postsByMonth = year.items | sort:"date" | group_by_exp:"post", "post.date | date: '%B'" %}

{% for month in postsByMonth reversed %}
<section id="{{ year.name }}-{{ month.name | date: '%m' }}" class="level2">
  <h2 class="heading" id="{{ year.name }}-{{ month.name | date: '%m' }}">
  <a href="{{ post.url }}">{{ month.name | date: '%B' }}</a> </h2>

  <ul>
{% for post in month.items reversed %}
  <li id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
  <a href="/{{ post.collection }}">vol. {{ post.volume | capitalize }}</a>, <a href="{{ year.name }}#no-{{ post.number }}">no. {{ post.number }}</a> {% if post.description %} &mdash; <span class="post-description">{{ post.description }}</span>{% endif %}
</li>
{% if post.abstract %}<aside class="abstract"><blockquote>{{ post.abstract }}</blockquote></aside>{% endif %}
{% endfor %}
  </ul>
</section>
{% endfor %}
</section>
{% endfor %}


{% assign date_format = "%b %d %Y" %}
