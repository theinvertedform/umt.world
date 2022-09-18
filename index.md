---
title: index
abstract: This is the personal website of **Uriah Marc Todoroff**.
---

<article id="index">

<div class="abstract">{{ page.abstract | markdownify }}</div>

<section id="newest">
<h1>New</h1>
<ul>
{% for post in site.posts %}
<li><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title | markdownify }}</a>
{% if post.lede %}<p><em>{{ post.lede }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="blog">
<h1>Blog</h1>
<ul>
{% for post in site.categories.blog %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
</li>
{% endfor %}
</ul>
</section>

{% for category in site.categories %}
{% unless category contains "blog" %}

<section id="{{ category[0] }}">
<h1>{{ category[0] | capitalize }}</h1>
<ul>
{% for post in category[1] %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.last_revision %} Originally published {{ post.last_revision | date: "%b %-d, %Y"}}.{% endif %}
</li>
{% endfor %}
</ul>
</section>
{% endunless %}
{% endfor %}
</article>
