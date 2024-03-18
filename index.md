---
title: Index
abstract: This is the personal website of **Uriah Marc Todoroff**. I am a writer and philosopher interested in art, history, and the present. I publish critical writing on modern culture and its origins, and stories about how it feels to live in the contemporary Now. [This website](/about#evolution) is an evolving experiment in new media design. It combines literary and [technical means](/about) to develop a *dialetical image* of the present from the outside.
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

<section id="film">
<h1 id="film"><a href="https://letterboxd.com/theinvertedform/films/diary">Film Diary</a></h1>
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

<section id="literary-criticism">
<h1 id="literary-criticism"><a href="/index#literary-criticism">Literary Criticism</a></h1>
<ul class="section-link-list">
{% for post in site.criticism reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="marxism">
<h1 id="marxism"><a href="/index#marxism">Marxism</a></h1>
<ul class="section-link-list">
{% for post in site.marxism reversed limit: 10 %}
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

</div>
</article>
