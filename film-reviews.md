---
title: Index of Film Reviews
description: An ongoing list of film reviews, synced from Letterboxd.
abstract:
status: ongoing
toc: true
permalink: /reviews/films
layout: post
---

Hello?

{% for post in site.categories %}
{% if category contains "film review" %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
{% endif %}
{% endfor %}
