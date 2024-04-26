---
title: Blog
layout: post
description: "Selections from my diary---highly confessional emotional processing, fragments, gossip, writing notes and experiments."
abstract: In 2004--2005, I shocked and embarrassed classmates with the excessive candour of my MySpace blog posts. That was one of my earliest experiences publishing my confessions on the basis of an instinct, without considering the consequences. Why do I publish such detail as you will find here, when I am generally reserved in person? Is the diary a literary genre like autofiction, something like autobiographical journalism? A large part of a diary's utility is therapeutic, and its contents can be said to reflect the mind that writes it. Here you will find the patterns of thought that my mind is inclined to---in all their negativity.
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
		<time itemprop="datePublished">{{ post.date | date: '%d (%a)' }}</a>
{% if post.title %}<span class="blog-post-title">{{ post.title }}</span>{% endif %}
 		</time>
</h3>
{% if post.description %}<span class="blog-post-description">{{ post.description }}</span>{% endif %}

</div>

{{ post.content }}

</section>
{% endfor %}
</section>
{% endfor %}
</section>
{% endfor %}
