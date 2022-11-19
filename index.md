---
title: index
abstract: This is the personal website of **Uriah Marc Todoroff**. I am a writer and philosopher whose practise is predicated on a continuous encounter with the real of contemporary culture. I cover a range of media including film, art, literature, and popular culture, in their emerging form as well as their history. I also write fiction.
toc: false
---

<article>
<div class="markdownBody" id="markdownBody">
<aside class="abstract">{{ page.abstract | markdownify }}</aside>

<section id="newest">
<h1><a href="/changes">New</a></h1>
<ul>
{% for post in site.posts limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title | markdownify }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="blog">
<h1><a href="/blog">Blog</a></h1>
<ul>
{% for post in site.categories.blog limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
</li>
{% endfor %}
</ul>
</section>

<section id="podcast">
<h1><a href="/podcast">Podcast</a></h1>
<ul>
{% for post in site.categories.podcast limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
</li>
{% endfor %}
</ul>
</section>

{% for category in site.categories %}
{% unless category contains "blog" %}
{% unless category contains "Footnotes to Endnotes" %}
{% unless category contains "podcast" %}
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
{% endunless %}
{% endunless %}
{% endfor %}

</div>
</article>
