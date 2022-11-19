---
title: Podcast
layout: post
description: Footnotes to Endnotes is your communizer radio hour.
abstract: A podcast collaboration between myself and Owen Gilbride. Episodes are currently offline, but efforts are underway to re-upload them.
tags:
  - communism
  - audio
  - podcast
toc: true
permalink: /podcast
---

{% assign sorted_posts = site.posts %}
{% for post in sorted_posts %}
{% if post.category == "podcast" %}
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
