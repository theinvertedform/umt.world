---
title: Blog
layout: post
description: "My diary falls open on the table for you to read: a practise of writing and an ongoing picture of my emotional state."
abstract: My blogging habits go back to a few initial posts on MySpace circa 2004--2005. These then evolved into alt.conform, a project hosted on Blogspot for many of my early teenage years. These writings are in addition to a constant practise of writing in notebooks and journals, some of which I occasionally transcribe and post here. My film review blog "Total Cinema" is archived over with my [reviews](/reviews). My approach with maintaing this blog page now is to use it to focus on maintaining my writing habit; and it also records an unbearably honest emotional record.
tags:
  - personal
  - writing
toc: true
status: ongoing
---

> I toss these pages in the faces of timid, furtive, respectable people and say: ‘There! that’s me! You may like it or lump it, but it’s true. And I challenge you to follow suit, to flash the searchlight of your self-consciousness into every remotest corner of your life and invite everybody’s inspection. Be candid, be honest, break down the partitions of your cubicle, come out of your burrow, little worm.’ As we are all such worms we should at least be honest worms.
> 
> [W.N.P Barbellion](https://en.wikipedia.org/wiki/W._N._P._Barbellion),_ [*Journal of a Disappointed Man*](https://www.pseudopodium.org/barbellionblog/books.html)

{% assign date_format = "%b %d %Y" %}
{% assign postsByYear = site.blog | sort | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear reversed %}
<section id="{{ year.name }}">
<h1 id="{{ year.name }}"><a href="/blog#{{ year.name }}">{{ year.name }}</a></h1>
{% assign postsByMonth = year.items | sort | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth reversed %}
<section id="{{ year.name }}-{{ month.name | date: '%m' }}">
<h2 id="{{ year.name }}-{{ month.name | date: '%m' }}">
	<a href="#{{ year.name }}-{{ month.name | date: '%m' }}">{{ month.name | date: '%B' }}</a>
</h2>
{% for post in month.items reversed %}
<section class="blog-post" id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
<div class="blog-post-header">
<h3 id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}" class="blog-post-date">
	<a href="#{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %e, %Y." }}">
		<time itemprop="datePublished">{{ post.date | date: date_format }}</time>
	</a>
</h3>
<span class="blog-post-title">{{ post.title }}</span>
{% if post.description %}<span class="blog-post-description">{{ post.description }}</span>{% endif %}

</div>

{{ post.content }}

</section>
{% endfor %}
</section>
{% endfor %}
</section>
{% endfor %}

# Works Cited
