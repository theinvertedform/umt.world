---
title: Categories
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
