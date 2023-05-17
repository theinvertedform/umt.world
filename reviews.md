---
title: Reviews
layout: post
description: Master list of reviews.
abstract: Mostly film reviews, but also art and books reviews. Occasionally talking about random works.
tags:
  - review
  - criticism
toc: true
permalink: /reviews
status: ongoing
---

{% assign film_reviews = site.reviews | where: "category","film_review" %}
{% for film_review in film_reviews%}
<h2><a href="{{ film_review.url }}" title="{{ film_review.title }}, posted on {{ film_review.date | date: "%b %-d, %Y" }}">{{ film_review.title }} ({{ film_review.date | date: '%Y' }})</a></h2>
<header class="post-header">
{% if film_review.tags.size > 0 %}
<div class="link-tags">{% for tag in film_review.tags %}<a href="/tags#{{ tag | slugify }}">{{ tag }}</a>
{% unless forloop.last %}&nbsp;{% endunless %}
{% endfor %}
</div>
{% endif %}
<time itemprop="datePublished">
{%- assign date_format =  "%b %-d, %Y" -%}
{{ post.date | date: date_format }} {% if post.modified %} &mdash; {{ post.modified | date: date_format }} &mdash; {% endif %} 
</time>
{% if post.description %}
<em>{{ post.description }}</em>
{% endif %}
</header>
{% if film_review %}
{{ film_review.review }}
{% endif %}

{% endfor %}
