---
title: index
abstract: This is the personal website of **Uriah Marc Todoroff**. I am a philosopher interested in the Marxist tradition and the philosophy of art; I am an historical researcher charting the social history of visual culture; and I am a [critical writer of the contemporary](/reviews). This website is a new media experiment, combining literary and [technical means](/about) to develop a [dialetical image](/benjamin#dialectical-image) of the present.
---
{%- assign date_format =  "%b %d %Y" -%}

<article>
<div class="markdownBody" id="markdownBody">
<aside class="abstract">{{ page.abstract | markdownify }}</aside>

<section id="new">
<h1><a href="/changes">New</a></h1>
<ul class="section-link-list">
{% assign sorted = site.documents | sort: 'date' | reverse %}
{% for post in sorted limit: 15 %}
<li>{% if post.url %}<a href="{{ post.url }}">{{ post.title }}</a>{% else %}<a href="{{ post.slug }}" title="{{ post.title }}, posted on {{ page.date | date: site.date_format }}.">{{ post.title }}</a>{% endif %}
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="blog">
<h1><a href="/blog">Blog</a></h1>
<ul class="section-link-list">
{% for post in site.blog reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: date_format }}">{{ post.date | date: date_format }}</a>
{% if post.title %}<span class="section-link-list-post-title">{{ post.title }}</span>{% endif %}
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="podcast">
{% assign episodes = site.podcast %}
<h1><a href="/podcast">Podcast</a></h1>
<ul class="section-link-list">
{% for post in episodes reversed limit: 10 %}
<li><a href="podcast#{{ post.slug }}" title="{{ post.title }}, posted on {{ post.date | date: site.date_format }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="reviews">
{% assign film_reviews = site.reviews | where:"grouped_by","film review" %}
<h1><a href="/index#reviews">Reviews</a></h1>
<ul class="section-link-list">
{% for post in film_reviews reversed limit: 10 %}
<li><a href="{{ post.slug }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="philosophy">
<h1 id="philosophy"><a href="/index#philosophy">Philosophy</a></h1>
<ul class="section-link-list">
{% for post in site.philosophy reversed limit: 10 %}
<li><a href="{{ post.slug }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="communism">
<h1 id="communism"><a href="/index#communism">Communism</a></h1>
<ul class="section-link-list">
{% for post in site.communism reversed limit: 10 %}
<li><a href="{{ post.slug }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>
</div>
</article>
