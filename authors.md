---
layout: default
title: Contributors
---

On my personal website, I occasionally publish writing by people other than myself. This may be for test purposes, or it may be for purposes of spreading something that I think is important. Below is an index of such authors, with links to their contributions.

{% for author in site.data.authors %}
<section>
<h2 id="{{ author[1].short_name }}"><a href="#{{ author[1].short_name | slugify }}">{{ author[1].name }}</a></h2>
<p>{{ author[1].bio | markdownify }}</p>
<ul>
{% assign filtered_posts = site.posts | where: 'author', author[1].short_name %}
{% for post in filtered_posts %}
  <li><a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
</section>
{% endfor %}
