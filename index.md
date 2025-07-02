---
title: Index
abstract: "This is the website of **Uriah Marc Todoroff**. I am a writer interested in contemporary life. Below you will find links to my writing, which includes criticism and narrative experiments. This website is an *outsider* project that combines design, information architecture, and literary craft.


For more about the philosophy of the website, visit the [*About the Website*](/about) page; for more about me and my [contact information](/links#contact), visit the [*About the Author*](/links) page. Subscribe to the [newsletter](https://news.umt.world) to receive updates in your inbox. The index below contains [critical writing](/index#culture), [book reviews](/index#books) and craft essays, and [interviews](/index#interviews) on philosophy and politics. There is a secret narrative hidden in the [margins](/diaries)."
layout: home
---

{%- assign date_format =  "%b %d %Y" -%}

<article itemscope itemtype="http://schema.org/WebPage">
<div class="markdownBody" id="markdownBody" itemprop="mainContentOfPage">
<aside class="index abstract" itemprop="description">{{ page.abstract | markdownify }}</aside>

<section id="new" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/changes" title="Reverse chronological list of additions to the website.">Newest</a></h1>
<ul class="section-link-list">
{% for collection in site.collections %}
{% unless collection.label == "film" %}
{% assign all_documents = all_documents | concat: collection.docs %}
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
<h1 class="index-heading"><a href="#notable" title="All the work that I am most proud of.">Notable</a></h1>
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
<a href="/culture/drones">Return to Drones</a>
</li>
<li>
<a href="/culture/light-enough-to-burn-a-hole-in-the-sun">Light Enough to Burn a Hole in the Sun</a>
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
{% for post in site.personal %}
{% if post.category contains 'diaries' %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endif %}
{% endfor %}
</ul>
</section>

<hr class="index-section-ornament" >

<section id="books" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/index#books" title="The umt.world Review of Books">The Mile End Review of Books</a></h1>
<ul class="section-link-list">
{% for post in site.books reversed limit: 10 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>

<section id="culture" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/index#culture" title="Writing on all cultural objects that are not books.">Margins of Culture</a></h1>
<ul class="section-link-list">
{% for post in site.culture reversed %}
{% unless post.categories contains "total cinema" %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endunless %}
{% endfor %}
<li>
<a href=/total-cinema>Total Cinema (2009--2011)</a>
</li>
</ul>
</section>

{% if site.criticism.size > 0 %}
<section id="criticism" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/reviews" title="Criticism deals with more abstract and theoretical issues.">Critique of Now</a></h1>
<ul class="section-link-list">
{% for post in site.criticism reversed limit: 10 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>
{% endif %}

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
<h1 class="index-heading" id="stories"><a href="/index#stories">Tales of the Turbo Age</a></h1>
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
<h1 class="index-heading"><a href="/podcast" title="A podcast from when we all got into left communism during the pandemic.">Podcast</a></h1>
<ul class="section-link-list">
{% for post in site.podcast reversed limit: 10 %}
{% if post.category contains 'Footnotes to Endnotes' %}
<li>
<a href="podcast#{{ post.slug }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endif %}
{% endfor %}
</ul>
</section>

<section id="newsletter" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/newsletter" title="The culture diary of an artworld outsider.">Newsletter Archives</a></h1>
<ul class="section-link-list">
{% for post in site.newsletter reversed limit: 10 %}
<li>
<a href="{{ post.url }}" itemprop="url">
<span itemprop="name">{{ post.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>

</div>
</article>
