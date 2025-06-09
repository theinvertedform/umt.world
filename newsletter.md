---
title: Newsletter Archives
description: "The culture diary of an artworld outsider."
abstract: Look at a prolific writer like Henry James, George Eliot, or Thomas Mann, and you will find that their unpublished writing is as voluminous as their published corpus. Letters, diaries, and short-form writing are the first stages in a pipeline to the works they are remembered for. umt.world as a unique literary form (a website) is an experiment in marketing. All of my writing, for better or for worse, is part of my oeuvre. The newsletter, then, collects snippets from my Diary, from my camera, from the websites that I post reviews and other writings. It also represents a direct link between me and you.
toc:  true
date: 2025-01-31
published: true
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
  <a href="#{{ year.name }}-{{ month.name | date: '%m' }}">{{ month.name | date: '%B' }}</a> </h2>

  <ul>
{% for post in month.items reversed %}
  <li id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
  <a href="{{ post.url }}">{{ post.title }}</a> {% if post.description %} &mdash; <span class="post-description">{{ post.description }}</span>{% endif %}
</li>
{% endfor %}
  </ul>
</section>
{% endfor %}
</section>
{% endfor %}


{% assign date_format = "%b %d %Y" %}
