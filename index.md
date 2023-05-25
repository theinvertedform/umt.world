---
title: Index
abstract: This is the personal website of **Uriah Marc Todoroff**. I am a philosopher interested in the Marxist tradition and the philosophy of art; I am an historical researcher charting the social history of visual culture; and I am a critical writer of contemporary art and cinema. This website is a new media experiment, combining literary and [technical means](/about) to develop a *dialetical image* of the present.
---
{%- assign date_format =  "%b %d %Y" -%}

<article>
<div class="markdownBody" id="markdownBody">
<aside class="abstract">{{ page.abstract | markdownify }}</aside>

<section id="new">
<h1><a href="/changes">New</a></h1>
<ul class="section-link-list">
{% for collection in site.collections %}
{% unless collection.label == "blog" %}
{% assign all_documents = all_documents | concat: collection.docs %}
{% endunless %}
{% endfor %}
{% assign sorted = all_documents | sort: 'date' | reverse | slice: 0, 10 %}
{% for post in sorted %}
<li>
{% if post.url %}
<a href="{{ post.url }}">{{ post.title }}</a>
{% else %}
<a href="{{ post.slug }}" title="{{ post.title }}, posted on {{ post.date | date: site.date_format }}.">{{ post.title }}</a>
{% endif %}
<em>{{ post.description }}</em>
</li>
{% endfor %}
</ul>
</section>

<section id="blog">
<h1><a href="/blog">Blog</a></h1>
<ul class="section-link-list">
{% assign sortedPosts = site.blog | sort: 'date' | reverse %}
{% for post in sortedPosts limit: 10 %}
<li>{% if post.title %}<a href="{{ post.url }}" title="{{ post.title }}, posted on {{ post.date | date: date_format }}">{{ post.title }}</a>{% endif %}
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

<section id="film">
<h1 id="film"><a href="/index#film">Film</a></h1>
<ul class="section-link-list">
{% for post in site.film reversed limit: 20 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, watched {{ post.watched_Date | date: "%m/%d/%y" }}. Review published {{ post.date | date: "%m/%d/%y" }}.">{{ post.name }}</a> ({{ post.year }})
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="art">
<h1 id="art"><a href="/index#art">Art</a></h1>
<ul class="section-link-list">
{% for post in site.art reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="philosophy">
<h1 id="philosophy"><a href="/index#philosophy">Philosophy</a></h1>
<ul class="section-link-list">
{% for post in site.philosophy reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

</div>
</article>
