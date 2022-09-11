---
title: Tags
---

{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
<section id="{{ tag[0] }}" class="index-category">
<h3>{{ tag[0] | capitalize }}</h3>
<ul>
    {% for post in tag[1] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
</ul>
</section>
{% endfor %}
