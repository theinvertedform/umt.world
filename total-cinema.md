---
title: Total Cinema Archives
description: "I am going to run my mouth about some things I know nothing about."
abstract:
date:
tags:
  - film
  - criticism
toc: true
---

{% assign total_cinema_posts = site.film | where: "category", "total cinema" %}
{% assign date_format = "%b %d %Y" %}

{% for post in total_cinema_posts %}
<section class="blog-post e-content level1" id="{{ post.slug }}" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/total-cinema#{{ post.slug }}">
<h1 id="{{ post.slug }}" title="'{{ post.title }}', posted on {{ post.date | date: "%b %e, %Y." }}">
	<a href="#{{ post.slug }}">{{ post.title }}</a>
</h1>
<hr>

<span itemprop="articleBody">
{{ post.content }}
</span>

{% if post.last_modified_at %}
<span class="blog-post-modified-date">Last edited {{ post.last_modified_at | date: date_format }}</span>
{% endif %}

{% endfor %}
</section>
