---
title: Blog
layout: post
description: "Selections from my diary---emotional processing, fragments of ideas, gossip, writing notes, shopping lists, daydreams and fantasies."
abstract: "In the ninth grade, I shocked and embarrassed classmates with the excessive candour of my blog posts on MySpace. I published my confessions following an instinct and without considering the consequences. I still publish my diary today as an experiment in narrative construction. This page takes influence from aphoristic writing, New Narrative, fragmentary writing, the diary, the autobiography, online writing, art criticism, and cognitive behavioural therapy. *Here are the words that I have left on my page, and in them you will see---the very distance that lies between truth and fiction, between life and art!*"
toc: true
status: ongoing
date: 2020-07-31
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
