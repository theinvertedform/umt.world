---
title: Categories
layout: post
description: Archive of posts sorted by category. Functionally identical to the index page.
abstract: The category system is a combination of standardized descriptions, and the concept of a column.
tags:
  - meta
  - bibliography
toc: true
---

{% assign sorted_categories = site.categories | sort %}
{% for category in sorted_categories %}
<section id="{{ category[0] }}" class="index-category">
<h3>{{ category[0] | capitalize }}</h3>
<ul>
    {% for post in category[1] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
</ul>
</section>
{% endfor %}
