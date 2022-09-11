---
title: index
---

This is the personal website of Uriah Marc Todoroff.

<section id="blog" class="index-category">
<h3>Blog Posts</h3>
<ul>
{% for post in site.categories.blog %}
{% assign author = site.data.authors[post.author] %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>{% if author %},
by <a href="{{ author.url }}">{{ author.name }}.</a>
{% else %}.{% endif %}
<p><emph>{{ post.excerpt | strip_html | truncate: 156 }}</emph></p>
</li>
{% endfor %}
</ul>
</section>

{% for category in site.categories %}
{% unless category contains "blog" %}

<section id="{{ category[0] }}" class="index-category">
<h3>{{ category[0] | capitalize }}</h3>
<ul>
{% for post in category[1] %}
{% assign author = site.data.authors[post.author] %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}{% if author %},</a>
by <a href="/authors#{{ author.short_name | slugify }}">{{ author.name }}.</a>
{% else %}</a>. {% endif %}
{% if post.origdate %} Originally published {{ post.origdate | date: "%b %-d, %Y"}}.{% endif %}
<p><emph>{{ post.excerpt | strip_html | truncate: 280 }}</emph></p>
</li>
{% endfor %}
</ul>
</section>
{% endunless %}
{% endfor %}
