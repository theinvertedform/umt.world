---
title: Footnotes to Endnotes
description: Footnotes to Endnotes is your communizer radio hour.
abstract: A podcast collaboration between myself and Owen Gilbride. Most episodes, except the two interviews, are currently offline.
status: on hiatus
tags:
  - communism
  - podcast
toc: true
---

{% for post in site.podcast reversed %}
<h1 id="{{ post.title | slugify }}"><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a></h1>
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

{% endfor %}

