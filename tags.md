---
title: Tags
layout: meta
description: Archive of posts sorted by tags.
abstract: The tagging system is currently non-standardized, and will need to be pruned at some point.
tags:
  - meta
  - bibliography
toc: true
---

{% assign tags = site.documents | map: 'tags' | uniq | sort_natural %}
{% for tag in tags %}
  <h1 id="{{ tag | slugify }}">{{ tag | capitalize }}</h1>
  <ul>
  {% for post in site.documents %}
    {% if post.tags contains tag %}
    <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endif %}
  {% endfor %}
  </ul>
{% endfor %}
