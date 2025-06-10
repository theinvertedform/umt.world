---
title: Tags
description: Archive of posts sorted by tags.
abstract: "My approach to tagging is based on the principles outlined by [Karl Voit](https://karl-voit.at/2022/01/29/How-to-Use-Tags/). My system is quite rudimentary right now."
tags:
  - meta
  - bibliography
toc: false
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
