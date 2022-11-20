---
title: index
abstract: This is the personal website of **Uriah Marc Todoroff**. I am a philosopher researching German Idealism and the Marxist philosophy of art; I am an historical researcher interested in modern aesthetics; and I am a writer with a critical practise based on a continuous encounter with contemporary art, film, and literature. I also write fiction.
---

<article>
<div class="markdownBody" id="markdownBody">
<aside class="abstract">{{ page.abstract | markdownify }}</aside>

<section id="new">
<h1><a href="/changes">New</a></h1>
<ul>
{% for collection in site.collections %}
{% for post in site[collection.label] reversed limit: 5 %}
<li><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title | markdownify }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
{% endfor %}
</ul>
</section>

<section id="blog">
<h1><a href="/blog">Blog</a></h1>
<ul>
{% for post in site.blog reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="podcast">
{% assign episodes = site.podcast %}
<h1><a href="/podcast">Podcast</a></h1>
<ul>
{% for post in episodes reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="reviews">
{% assign film_reviews = site.reviews | where:"grouped_by","film review" %}
<h1><a href="/index#reviews">Reviews</a></h1>
<ul>
{% for post in film_reviews reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="philosophy">
<h1 id="philosophy"><a href="/index#philosophy">Philosophy</a></h1>
<ul>
{% for post in site.philosophy reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="communism">
<h1 id="communism"><a href="/index#communism">Communism</a></h1>
<ul>
{% for post in site.communism reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<p><em>{{ post.description }}</em></p>{% endif %}
</li>
{% endfor %}
</ul>
</section>
</div>
</article>
