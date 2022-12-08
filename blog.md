---
title: Blog
layout: post
description: A diary-style collection of short posts. Generally, longer writings will find their way into another category.
abstract: I have been blogging for a long time. My earliest posts were on MySpace, but I quickly started a blogspot, which  I was active on for several years. I had some posts on LiveJournal, a xanga, and elsewhere. Archives of alt.conform, Total Cinema, The Vernissage Report, and everything else is forthcoming.
tags:
  - personal
  - blog
  - diary
toc: true
permalink: /blog
status: ongoing
---

> I toss these pages in the faces of timid, furtive, respectable people and say: ‘There! that’s me! You may like it or lump it, but it’s true. And I challenge you to follow suit, to flash the searchlight of your self-consciousness into every remotest corner of your life and invite everybody’s inspection. Be candid, be honest, break down the partitions of your cubicle, come out of your burrow, little worm.’ As we are all such worms we should at least be honest worms.
> 
> [W.N.P Barbellion](https://en.wikipedia.org/wiki/W._N._P._Barbellion),_ [*Journal of a Disappointed Man*](https://www.pseudopodium.org/barbellionblog/books.html)

{% for post in site.blog reversed %}
<h1 id="{{ post.title | slugify }}"><a href="blog#{{ post.title | slugify }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a></h1>
<header class="post-header">
{% if post.tags.size > 0 %}
<div class="link-tags">{% for tag in post.tags %}<a href="/tags#{{ tag | slugify }}">{{ tag }}</a>
{% unless forloop.last %}&nbsp;{% endunless %}
{% endfor %}
</div>
{% endif %}
<time itemprop="datePublished">
{%- assign date_format =  "%b %-d, %Y" -%}
{{ post.date | date: date_format }} {% if post.modified %} &mdash; {{ post.modified | date: date_format }}{% endif %} &mdash;
</time>
{% if post.description %}
<em>{{ post.description }}</em>
{% endif %}
</header>

{{ post.content }}

{% endfor %}
