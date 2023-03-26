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

<h2>Categories</h2>
{%- assign categories = site.categories -%}
{% for category in categories %}
    <h3>category title: {{ category.title }}</h3>
{% endfor %}

{% assign reviews = site.documents %}
{% for post in site.reviews reversed %}
<h1>cats</h1>
<h2><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }} ({{ post.date | date: '%Y' }})</a></h2>
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

{% if post.review %}
{{ post.review }}
{% endif %}

{% endfor %}
