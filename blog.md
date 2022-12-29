---
title: Blog
layout: post
description: Short diary posts and low-stakes writing exercises.
abstract: I have been blogging for a long time. I posted a few times on MySpace, which was the first social network I used to communicate with friends circa 2004--2005. I started a blogspot soon thereafter, where I was active for several years. I made a few posts on LiveJournal, Xanga, and elsewhere. I kept a film review blog for several months around 2009--2010. Someday I will get around to making all these archives public.
tags:
  - personal
  - blog
  - diary
  - writing exercises
toc: true
status: ongoing
---

> I toss these pages in the faces of timid, furtive, respectable people and say: ‘There! that’s me! You may like it or lump it, but it’s true. And I challenge you to follow suit, to flash the searchlight of your self-consciousness into every remotest corner of your life and invite everybody’s inspection. Be candid, be honest, break down the partitions of your cubicle, come out of your burrow, little worm.’ As we are all such worms we should at least be honest worms.
> 
> [W.N.P Barbellion](https://en.wikipedia.org/wiki/W._N._P._Barbellion),_ [*Journal of a Disappointed Man*](https://www.pseudopodium.org/barbellionblog/books.html)

{% assign postsByYear = site.blog | sort | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear reversed %}
<h1 id="{{ year.name }}"><a href="/blog#{{ year.name }}">{{ year.name }}</a></h1>
{% assign postsByMonth = year.items | sort | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth reversed %}
{% for post in month.items reversed %}
<h2 id="{{ year.name }}-{{ post.title | slugify }}"><a href="/blog#{{ year.name }}-{{ post.title | slugify }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a></h2>
<header class="post-header">
{% if post.tags.size > 0 %}
<div class="link-tags">{% for tag in post.tags %}<a href="/tags#{{ tag | slugify }}">{{ tag }}</a>
{% unless forloop.last %}&nbsp;{% endunless %}
{% endfor %}
</div>
{% endif %}
<time itemprop="datePublished">
{%- assign date_format =  "%b %-d, %Y" -%}
{{ post.date | date: date_format }} &mdash; {% if post.modified %}  {{ post.modified | date: date_format }}{% endif %} 
</time>
{% if post.description %}
<em>{{ post.description }}</em>
{% endif %}
{% if post.abstract %}
<aside class="abstract"><blockquote>{{ post.abstract }}</blockquote></aside>
{% endif %}
</header>

{{ post.content }}

{% endfor %}
{% endfor %}
{% endfor %}

