---
title: Index
abstract: "This is the personal website of **Uriah Marc Todoroff**. I am a writer interested in contemporary life. The website is an experiment in hypertext design and experimental writing.


For more about the philosophy of the website, visit the [*About*](/about) page; for more about me and my contact information, visit the [*About the Author*](/links) page. Subscribe to the [newsletter](umtworld.substack.com) for updates. The index below includes [critical writing](/index#reviews) on films and art; [essays](/index#essays) and [interviews](/index#interviews) on philosophy and politics; and a fictionalized [diary](/blog)."
layout: home
---
{%- assign date_format =  "%b %d %Y" -%}

<article>
<div class="markdownBody" id="markdownBody">
<aside class="abstract">{{ page.abstract | markdownify }}</aside>

<section id="new">
<h1 class="index-heading"><a href="/changes" title="Reverse chronological list of additions to my published canon.">Newest</a></h1>
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
<h1 class="index-heading"><a href="#notable" title="Writing and other media that I am most proud of, and which is most representative of my project.">Notable</a></h1>
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
<h1 class="index-heading"><a href="/blog" title="A fictionalized diary.">Diaries</a></h1>
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
<h1 class="index-heading" id="film"><a href="https://letterboxd.com/theinvertedform/films/diary" title="Film diary, including column reviews and letterboxd posts.">My Life in Movies</a></h1>
<ul class="section-link-list">
{% for post in site.film reversed limit: 20 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, watched {{ post.watched_Date | date: "%m/%d/%y" }}. Review published {{ post.date | date: "%m/%d/%y" }}.">{{ post.name }}</a> ({{ post.year }})
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="essays">
<h1 class="index-heading" id="essays"><a href="/index#essays" title="Essays are more concerned with a topic than a specific object.">Essays</a></h1>
<ul class="section-link-list">
{% for post in site.essays reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="reviews">
<h1 class="index-heading" id="reviews"><a href="/index#reviews" title="Reviews tend to be focused on one object or event, or a set of related objects or events.">Reviews</a></h1>
<ul class="section-link-list">
{% for post in site.reviews reversed limit: 10 %}
<li><a href="{{ post.url }}" title="{{ post.title}}, posted on {{ post.date | date: "%b %-d, %Y" }}">{{ post.title }}</a>
{% if post.description %}<em>{{ post.description }}</em>{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="interviews">
<h1 class="index-heading" id="interviews"><a href="/index#interviews" title="Interviews conducted by me, and of me.">Interviews</a></h1>
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
<h1 class="index-heading" id="stories"><a href="/index#stories">Stories</a></h1>
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
<h1 class="index-heading"><a href="/podcast" title="The podcast was a pandemic project.">Podcast</a></h1>
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
