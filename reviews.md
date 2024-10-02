---
title: Reviews
description: Canonical list of reviews published on umt.world.
abstract: "Typically I write my film and book reviews on Letterboxd and Goodreads. I have not yet gotten around to programatically archiving those posts, so the content on this page is a hand-picked selection. The texts collected here are the *canonical* version of reviews posted elsewhere.


There's a lot that remains to be done with this page.


1. Group the posts from my old film blog \"Total Cinema\" together. Those reviews were written in the style of a newspaper column, very different from my current practise of writing about film, and therefore feel like a categorically different body of writing.


2. How the page will be sorted remains an open question. Currently, the categories are sorted alphabetically, and the posts within are sorted by date. There should be some mechanism for floating the latest review to the top.


3. How do we keep the page from getting too long? I can't simply integrate every review I've posted on Letterboxd---there are hundreds, and it would render the TOC unusable, the page unnavigable."
tags:
  - reviews
  - criticism
status: ongoing
toc: true
---

{% assign categories = site.documents | map: 'category' | uniq | sort_natural %}
{% for category in categories %}
{% unless category == "Footnotes to Endnotes" %}
<h1 id="{{ category | slugify }}">{{ category | capitalize }}</h1>
{% for post in site.documents %}
{% if post.category contains category %}
<h2 id="{{ post.title | slugify }}"><a href="#{{ post.title | slugify }}">{{ post.title }}</a></h2>
{% if post.abstract %}
{{ post.abstract }}
{% else %}
{{ post.excerpt }}
{% endif %}
{% endif %}
{% endfor %}
{% endunless %}
{% endfor %}

{% assign film_reviews = site.reviews | where: "film_review","true" %}
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
