---
title: Index
abstract: "This is the personal website of **Uriah Marc Todoroff**. I am a writer interested in contemporary life. The website is an experiment in new media design and experimental writing.


For more about the philosophy of the website, visit the [*About*](/about) page; for more about me and my contact information, visit the [*About the Author*](/links) page. Subscribe to the [newsletter](umtworld.substack.com) for updates. The index below includes critical writing on [films](/index#film) and [art](/index#art); essays and interviews on philosophy and politics; and a fictionalized [diary](/blog)."
layout: home
---
{%- assign date_format =  "%b %d %Y" -%}

<article>
<div class="markdownBody" id="markdownBody">
<aside class="abstract">{{ page.abstract | markdownify }}</aside>

<section id="new">
<h1><a href="/changes">Newest</a></h1>
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
</li>
{% endfor %}
</ul>
</section>

<section id="notable">
<h1><a href="#notable">Notable</a></h1>
<ul class="section-link-list">
<li>
<a href="/reviews/light-enough-to-burn-a-hole-in-the-sun">Light Enough to Burn a Hole in the Sun</a>
</li>
<li>
<a href="/tending-the-revolutionary-garden">Tending the Revolutionary Garden</a>
</li>
<li>
<a href="/a-cryptoeconomy-of-affect">A Cryptoeconomy of Affect</a>
</li>
<li>
<a href="/blog#2023-03-18">Return to Drones</a>
</li>
<li>
<a href="https://letterboxd.com/theinvertedform/list/my-personal-canon/">My Film Canon</a>
</li>
<li>
<a href="https://letterboxd.com/theinvertedform/film/right-now-wrong-then/">Review of *Right Now, Wrong Then*</a>
</li>
</ul>
</section>

<section id="blog">
<h1><a href="/blog">Diaries</a></h1>
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
<h1 id="film"><a href="https://letterboxd.com/theinvertedform/films/diary">My Life in Movies</a></h1>
<ul class="section-link-list">
{% for post in site.film reversed limit: 20 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, watched {{ post.watched_Date | date: "%m/%d/%y" }}. Review published {{ post.date | date: "%m/%d/%y" }}.">{{ post.name }}</a> ({{ post.year }})
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="essays">
<h1 id="essays"><a href="/index#essays">Essays</a></h1>
<ul class="section-link-list">
{% for post in site.essays reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="reviews">
<h1 id="reviews"><a href="/index#reviews">Reviews</a></h1>
<ul class="section-link-list">
{% for post in site.reviews reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="interviews">
<h1 id="interviews"><a href="/index#interviews">Interviews</a></h1>
<ul class="section-link-list">
{% for post in site.interviews reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<!--
<section id="stories">
<h1 id="stories"><a href="/index#stories">Stories</a></h1>
<ul class="section-link-list">
{% for post in site.stories reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>
-->

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
