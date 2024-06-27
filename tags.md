---
title: Tags
description: Archive of posts sorted by tags.
abstract: The tagging system is currently BROKEN!
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
    <li><a href="{{ post.slug }}">{{ post.title }}</a></li>
    {% endif %}
  {% endfor %}
  </ul>
{% endfor %}
