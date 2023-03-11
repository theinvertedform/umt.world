---
title: Reviews
layout: post
description: Master list of reviews.
abstract: Mostly film reviews, but also art and books reviews. Occasionally talking about random works.
tags:
  - review
  - critique
toc: true
permalink: /reviews
status: ongoing
---

{% assign film_reviews = site.documents | group_by: "film review" %}
{% for post in site.reviews reversed %}
<h1><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }} ({{ post.date | date: '%Y' }})</a></h1>
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

{% endfor %}
