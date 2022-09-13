---
title: index
---

This is the personal website of Uriah Marc Todoroff.

<section id="new" class="index-category">
<h3>New</h3>
<ul>
{% for post in site.posts %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
<p><emph>{{ post.excerpt | strip_html | truncate: 156 }}</emph></p>
</li>
{% endfor %}
</ul>
</section>

<section id="blog" class="index-category">
<h3>Blog</h3>
<ul>
{% for post in site.categories.blog %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
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
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.last_revision %} Originally published {{ post.last_revision | date: "%b %-d, %Y"}}.{% endif %}
<p><emph>{{ post.excerpt | strip_html | truncate: 280 }}</emph></p>
</li>
{% endfor %}
</ul>
</section>
{% endunless %}
{% endfor %}
