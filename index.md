---
title: index
abstract: This is the personal website of **Uriah Marc Todoroff**. I am a writer and philosopher whose critical practise covers film, art, literature, and popular culture. I also write fiction.
toc: false
---

<article>
<div class="markdownBody" id="markdownBody">
<aside class="abstract">{{ page.abstract | markdownify }}</aside>

<section id="newest">
<h1>New</h1>
<ul>
{% for post in site.posts limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title | markdownify }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="blog">
<h1>Blog</h1>
<ul>
{% for post in site.categories.blog limit: 10 %}
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
{% for post in category[1] limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>
{% endunless %}
{% endfor %}

</div>
</article>
