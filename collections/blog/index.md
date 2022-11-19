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
---

{% assign sorted_posts = site.posts %}
{% for post in sorted_posts %}
{% if post.category == "blog" %}
<h1><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a></h1>
{% if post.tags.size > 0 %}
<div class="link-tags">{% for tag in post.tags %}<a href="/tags#{{ tag | slugify }}">{{ tag }}</a>
{% unless forloop.last %}&nbsp;{% endunless %}
{% endfor %}
</div>
{% endif %}
<time itemprop="datePublished">
{%- assign date_format = site.minima.date_format | default: "%b %-d, %Y" -%}
{{ post.date | date: date_format }} {% if post.modified %}&mdash;{{ post.modified | date: date_format }}{% endif %}</time>&mdash;

{{ post.content }}

{% endif %}
{% endfor %}
