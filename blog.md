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

{% assign date_format =  "%b %e, %Y" %}
{% assign postsByYear = site.blog | sort | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear reversed %}
<h1 id="{{ year.name }}"><a href="/blog#{{ year.name }}">{{ year.name }}</a></h1>
{% assign postsByMonth = year.items | sort | group_by_exp:"post", "post.date | date: '%B'" %}
{% assign mostRecentPost = nil %}
{% for month in postsByMonth reversed %}
{% for post in month.items reversed %}
<div class="blog-post">
{% if post.date > mostRecentPost.date or mostRecentPost == nil %}
{% assign mostRecentPost = post %}
{% endif %}

{% if post == mostRecentPost %}
<h2 id="{{ post.date | date: "%b-%Y" | slugify }}" class="blog-post-header">
<a href="/blog#{{ post.date | date: "%b-%Y" | slugify }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %e, %Y" }}">
<time itemprop="datePublished">{{ post.date | date: date_format }}</time>
</a>
</h2>
{% else %}
<h2 id="{{ post.date | date: date_format | slugify }}" class="blog-post-header">
<a href="/blog#{{ post.date | date: date_format | slugify }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %e, %Y" }}">
<time itemprop="datePublished">{{ post.date | date: date_format }}</time>
</a>
</h2>
{% endif %}

{{ post.content }}

</div>
{% endfor %}
{% endfor %}
{% endfor %}
