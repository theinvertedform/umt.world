---
title: Tags
layout: meta
description: Archive of posts sorted by tags.
abstract: The tagging system is based off of some protocol standard.
tags:
  - meta
  - bibliography
toc: true
---

{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
<h1>{{ tag[0] | capitalize }}</h1>
<ul>
    {% for post in tag[1] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
</ul>
{% endfor %}
