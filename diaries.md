---
title: Diaries
description: "Selections from a diary. Patterns, ideas, gossip, writing notes, shopping lists, daydreams, fantasies."
abstract: "In the ninth grade, my classmates were shocked by the excessive candour of my MySpace blog posts. I published the truth of how I felt without considering the consequences. The diary that I publish today is an ongoing experiment in autofictional narrativization---a story based in memoir; an aestheticized residue of a process of living. Nothing here should be taken as 'true,' but everything is based in reality."
toc: true
status: ongoing
date: 2023-09-01
---

:::{.epigraph}
> I toss these pages in the faces of timid, furtive, respectable people and say: ‘There! that’s me! You may like it or lump it, but it’s true. And I challenge you to follow suit, to flash the searchlight of your self-consciousness into every remotest corner of your life and invite everybody’s inspection. Be candid, be honest, break down the partitions of your cubicle, come out of your burrow, little worm.’ As we are all such worms we should at least be honest worms.
>
> [@barbellion1919](https://www.pseudopodium.org/barbellionblog/books.html)
:::

{% assign date_format = "%b %d %Y" %}

<section class="e-content level2" id="the-beginning-of-a-longer-journey" itemscope itemtype="http://schema.org/CollectionPage" itemid="https://umt.world/diaries#the-beginning-of-a-longer-journey">
<h2 class="heading diary">
	<a href="#the-beginning-of-a-longer-journey">The Beginning of a Longer Journey</a>
</h2>
{% assign start_date = "2023-09-01" | date: "%s" %}
{% assign end_date = "2023-10-13" | date: "%s" %}
{% for post in site.personal %}
{% assign post_date = post.date | date: "%s" %}
{% if post.category == "diaries" and post_date >= start_date and post_date <= end_date %}
<article class="level3" id="{{ post.slug }}" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/diaries#{{ post.slug }}">
<h3 itemprop="headline">{{ post.date | date: "%A" }}</h3>
<meta itemprop="datePublished" content="{{ post.date | date_to_xmlschema }}">
<div itemprop="articleBody">
{{ post.content }} {% if post.last_modified_at %}<span class="blog-post-modified-date">{{ post.last_modified_at | date: "%x" }}</span>{% endif %}
</div>
</article>
{% endif %}
{% endfor %}
</section>

<section class="blog-post e-content level2" id="all-the-interim-is-like-a-hideous-dream" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/diaries#all-the-interim-is-like-a-hideous-dream">
<h2 class="heading diary">
	<a href="#all-the-interim-is-like-a-hideous-dream">All the Interim is Like a Hideous Dream</a>
</h2>
<hr>
{% assign start_date = "2023-10-14" | date: "%s" %}
{% assign end_date = "2023-11-29" | date: "%s" %}
{% for post in site.personal %}
{% assign post_date = post.date | date: "%s" %}
{% if post.category == "diaries" and post_date >= start_date and post_date <= end_date %}
<article class="level3" id="{{ post.slug }}" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/diaries#{{ post.slug }}">
<h3 itemprop="headline">{{ post.title }}</h3>
<meta itemprop="datePublished" content="{{ post.date | date_to_xmlschema }}">
<div itemprop="articleBody">
{{ post.content }}
</div>
{% if post.last_modified_at %}
<span class="blog-post-modified-date">Last edited {{ post.last_modified_at | date: date_format }}</span>
{% endif %}
</article>
{% endif %}
{% endfor %}
</section>

<section class="blog-post e-content level2" id="all-the-interim-is-like-a-hideous-dream-2" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/diaries#all-the-interim-is-like-a-hideous-dream-2">
<h2 class="heading diary">
	<a href="#all-the-interim-is-like-a-hideous-dream-2">All the Interim is Like a Hideous Dream</a>
</h2>
<hr>
{% assign start_date = "2023-12-02" | date: "%s" %}
{% assign end_date = "2024-02-19" | date: "%s" %}
{% for post in site.personal %}
{% assign post_date = post.date | date: "%s" %}
{% if post.category == "diaries" and post_date >= start_date and post_date <= end_date %}
<article class="level3" id="{{ post.slug }}" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/diaries#{{ post.slug }}">
<h3 itemprop="headline">{{ post.title }}</h3>
<meta itemprop="datePublished" content="{{ post.date | date_to_xmlschema }}">
<div itemprop="articleBody">
{{ post.content }}
</div>
{% if post.last_modified_at %}
<span class="blog-post-modified-date">Last edited {{ post.last_modified_at | date: date_format }}</span>
{% endif %}
</article>
{% endif %}
{% endfor %}
</section>

<section class="blog-post e-content level2" id="a-king-in-spite-of-the-devil" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/diaries#a-king-in-spite-of-the-devil">
<h2 class="heading diary">
	<a href="#a-king-in-spite-of-the-devil">A King in Spite of the Devil</a>
</h2>
<hr>
{% assign start_date = "2024-02-22" | date: "%s" %}
{% assign end_date = "2024-03-18" | date: "%s" %}
{% for post in site.personal %}
{% assign post_date = post.date | date: "%s" %}
{% if post.category == "diaries" and post_date >= start_date and post_date <= end_date %}
<article class="level3" id="{{ post.slug }}" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/diaries#{{ post.slug }}">
<h3 itemprop="headline">{{ post.title }}</h3>
<meta itemprop="datePublished" content="{{ post.date | date_to_xmlschema }}">
<div itemprop="articleBody">
{{ post.content }}
</div>
{% if post.last_modified_at %}
<span class="blog-post-modified-date">Last edited {{ post.last_modified_at | date: date_format }}</span>
{% endif %}
</article>
{% endif %}
{% endfor %}
</section>
