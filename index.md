---
title: Index
abstract: "This is the website of **Uriah Marc Todoroff**. I am a writer interested in contemporary life. Below you will find links to writing published here and elsewhere, online & in print. This website is an ongoing experiment that combines hypertext design, information architecture, and experimental narrative.


For more about the philosophy of the website, visit the [*About the Website*](/about) page; for more about me and my [contact information](/links#contact), visit the [*About the Author*](/links) page. Subscribe to the [newsletter](umtworld.substack.com) to receive updates in your inbox. This index includes [critical writing](/reviews) on films and art; [essays](/index#essays) and [interviews](/index#interviews) on philosophy and politics; and a fictionalized [diary](/diaries)."
layout: home
---
{%- assign date_format =  "%b %d %Y" -%}

<article itemscope itemtype="http://schema.org/WebPage">
<div class="markdownBody" id="markdownBody" itemprop="mainContentOfPage">
<aside class="index abstract" itemprop="description">{{ page.abstract | markdownify }}</aside>

<section id="new" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/changes" title="Reverse chronological list of additions to my published canon.">Newest</a></h1>
<ul class="section-link-list">
{% for collection in site.collections %}
{% unless collection.label == "blog" %}
{% unless collection.label == "film" %}
{% assign all_documents = all_documents | concat: collection.docs %}
{% endunless %}
{% endunless %}
{% endfor %}
{% assign sorted = all_documents | sort: 'date' | reverse | slice: 0, 10 %}
{% for post in sorted %}
<li>
{% if post.url %}
<a href="{{ post.url }}" itemprop="url"><span itemprop="name">{{ post.title }}</span></a>
{% else %}
<a href="{{ post.slug }}" title="{{ post.title }}, posted on {{ post.date | date: site.date_format }}.">{{ post.title }}</a>
{% endif %}
</li>
{% endfor %}
</ul>
</section>

<section id="notable" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="#notable" title="Writing and other media that I am most proud of.">Notable</a></h1>
<ul class="section-link-list">
<li>
<a href="https://letterboxd.com/theinvertedform/list/my-personal-canon/">My Film Canon</a>
</li>
<li>
<a href="https://www.goodreads.com/review/list/122256622-uriah-todoroff?shelf=favourites">My Favourite Books</a>
</li>
<li>
<a href="/interviews/tending-the-revolutionary-garden">Tending the Revolutionary Garden</a>
</li>
<li>
<a href="/interviews/a-cryptoeconomy-of-affect">A Cryptoeconomy of Affect</a>
</li>
<li>
<a href="/reviews/drones">Return to Drones</a>
</li>
<li>
<a href="/light-enough-to-burn-a-hole-in-the-sun">Light Enough to Burn a Hole in the Sun</a>
</li>
<ul>
<li>
<a href="/commentary-on-light">*Commentary*</a>
</li>
</ul>
<li>
<a href="https://letterboxd.com/theinvertedform/film/right-now-wrong-then/">Review of *Right Now, Wrong Then*</a>
</li>
</ul>
</section>

<section id="diaries" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/diaries" title="A fictionalized diary.">Diaries</a></h1>
<ul class="section-link-list">
{% assign sortedPosts = site.diary | sort: 'date' %}
{% for post in sortedPosts limit: 10 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>

<hr class="index-section-ornament" >

<section id="film" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="https://letterboxd.com/theinvertedform/films/diary" title="Film diary, including column reviews and letterboxd posts.">My Life in Movies</a></h1>
<ul class="section-link-list">
{% for post in site.film reversed limit: 20 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.name }}</span> ({{ post.year }})
</a>
</li>
{% endfor %}
</ul>
</section>

<section id="essays" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/index#essays" title="Essays are more concerned with a topic than a specific object.">Essays</a></h1>
<ul class="section-link-list">
{% for post in site.essays reversed limit: 10 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>

<section id="reviews" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/reviews" title="Reviews tend to be focused on one object or event, or a set of related objects or events.">Reviews</a></h1>
<ul class="section-link-list">
{% for post in site.reviews reversed limit: 10 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>

<section id="interviews" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/index#interviews" title="Interviews conducted by me, and of me.">Interviews</a></h1>
<ul class="section-link-list">
{% for post in site.interviews reversed limit: 10 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
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

<section id="podcast" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
{% assign episodes = site.podcast %}
<h1 class="index-heading"><a href="/podcast" title="The podcast was a pandemic project.">Podcast</a></h1>
<ul class="section-link-list">
{% for post in episodes reversed limit: 10 %}
<li>
<a href="podcast#{{ post.slug }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>

</div>
</article>
