---
title: Index
abstract: "This is the website of **Uriah Marc Todoroff**. I am a writer interested in contemporary life. I write about literature, film, the visual arts, and culture more generally. I also practice writing in a post-fictional mode. This website is an index of work published in various magazines, journals, and on other websites. It is also its own literary work. My only goal with this website is to systematically show what it means that we live as we do today.


To learn more about new media and the design of this website, read [*About the Website*](/about). For more about me and my motivations, read [*About the Author*](/links). This website is constantly in development. The best way to stay updated is to subscribe to the [newsletter](https://news.umt.world), which I only send occasionally. The index below contains [critical writing](/#culture) about art and film, [book reviews](/#books), fiction, and [interviews](/#interviews) with artists and philosophers. The [*Diaries*](/diaries) develop a chronological narrative."
layout: home
hero: "/assets/images/kubik2000/kubik2000.jpg"
hero_focus: 50% 15%
hero_caption: "Scenes From a Marriage, Tomáš Kubík, 2000."
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
{% unless collection.label == "newsletter" %}
{% assign all_documents = all_documents | concat: collection.docs %}
{% endunless %}
{% endunless %}
{% endfor %}
{% assign sorted = all_documents | sort: 'date' | reverse | slice: 0, 10 %}
{% for post in sorted %}
<li>
{% if post.collection == "diaries" %}
<a href="/diaries#{{ post.date | date: '%Y-%m-%d' }}ff" itemprop="url"><span itemprop="name">{{ post.title }}</span></a>
{% elsif post.url %}
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
{% include notable.html %}
</section>

<section id="diaries" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="/diaries" title="A fictionalized diary.">Diaries</a></h1>
<ul class="section-link-list">
{% assign chapters = site.diaries | sort: 'date' %}
{% for chapter in chapters limit: 10 %}
<li>
<a href="/diaries#{{ chapter.date | date: '%Y-%m-%d' }}ff" itemprop="url">
<span itemprop="name">{{ chapter.title }}</span>
</a>
</li>
{% endfor %}
</ul>
</section>

<hr class="index-section-ornament" >

<section id="books" itemprop="hasPart" itemscope itemtype="http://schema.org/SiteNavigationElement">
<h1 class="index-heading"><a href="#books" title="The umt.world Review of Books">Mile End Review of Books</a></h1>
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
<h1 class="index-heading"><a href="#culture" title="Writing on all cultural objects that are not books.">Margins of Culture</a></h1>
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
<h1 class="index-heading"><a href="#interviews" title="Interviews conducted by me, and of me.">In Conversation</a></h1>
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
<section id="fiction">
<h1 class="index-heading"><a href="/#fiction" title="Fiction, although the distinction is not clean on this website.">Tales from Beneath Language</a></h1>
<ul class="section-link-list">
{% for post in site.fiction reversed limit: 10 %}
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
<h1 class="index-heading"><a href="/newsletter" title="The culture diary of an artworld outsider.">A Bundle of Letters</a></h1>
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

