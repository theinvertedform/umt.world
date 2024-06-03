---
title: Diaries
layout: post
description: "Selections from my diaries, edited into a fictional work. Emotional patterns, ideas, gossip, writing notes, shopping lists, daydreams and fantasies."
abstract: "In the ninth grade, my classmates were shocked by the excessive candour of my MySpace blog posts. I published the truth of how I felt without considering the consequences. The diary that I publish today is an ongoing experiment in autofictional narrativization---a story based in memoir, an aestheticized residue of a process of art and living---unfinished until the *point final*. Nothing here should be taken as 'true,' but everything is based in reality.


The writing on this page is influenced by New Narrative, online writing, diary writing, the autobiography, contemporary art and cinema, and cognitive behavioural therapy. *Here are the words that I have left on my page, and in them you will see---the very distance that lies between truth and fiction, between life and art!*"
toc: true
status: ongoing
date: 2020-07-31
---

<blockquote class="epigraph">
I toss these pages in the faces of timid, furtive, respectable people and say: ‘There! that’s me! You may like it or lump it, but it’s true. And I challenge you to follow suit, to flash the searchlight of your self-consciousness into every remotest corner of your life and invite everybody’s inspection. Be candid, be honest, break down the partitions of your cubicle, come out of your burrow, little worm.’ As we are all such worms we should at least be honest worms.

[W.N.P Barbellion](https://en.wikipedia.org/wiki/W._N._P._Barbellion),_ [*Journal of a Disappointed Man*](https://www.pseudopodium.org/barbellionblog/books.html)

</blockquote>

<blockquote class="epigraph">
I IX (*1914*)---In complete helplessness wrote barely 2 pages. I have retreated considerably today, even though I had slept well. But I know that I must not yield, if I want to rise above the lowest woes of my writing, which is already held down by the rest of my way of life, into the greater freedom that might be waiting for me. The old dullness has not yet completely left me I realize and the coldness of my heart might never leave me. The fact that I recoil from no humiliation can just as well mean hopelessness as give hope.

--- [@kafka2022, 356]

</blockquote>

<blockquote class="epigraph">
You adulterate the truth as you write. There isn't any pretense that you try to arrive at the literal truth. And the only consolation when you confess to this flaw is that you are seeking to arrive at poetic truth, which can be reached only through fabrication, imagination, stylization. What I'm striving for is authenticity; none of it is real.

--- W. G. Sebald, quoted in [@shields2010, 62]

</blockquote>

{% assign date_format = "%b %d %Y" %}

{% assign postsByYear = site.blog | sort | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear reversed %}
<section id="{{ year.name }}">
<h1 id="{{ year.name }}"><a href="/blog#{{ year.name }}">{{ year.name }}</a></h1>
{% assign postsByMonth = year.items | sort | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth reversed %}
<section id="{{ year.name }}-{{ month.name | date: '%m' }}">
<h2 id="{{ year.name }}-{{ month.name | date: '%m' }}">
	<a href="#{{ year.name }}-{{ month.name | date: '%m' }}">{{ month.name | date: '%B' }}</a>
</h2>
{% for post in month.items reversed %}
<section class="blog-post" id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
<div class="blog-post-header">
<h3 id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}" class="blog-post-date">
	<a href="#{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}" title="{{ post.title }}, posted on {{ post.date | date: "%b %e, %Y." }}">
		<time itemprop="datePublished">{{ post.date | date: '%d (%a)' }}</a>
{% if post.title %}<span class="blog-post-title">{{ post.title }}</span>{% endif %}
 		</time>
</h3>
{% if post.description %}<span class="blog-post-description">{{ post.description }}</span>{% endif %}

</div>

{{ post.content }}

</section>
{% endfor %}
</section>
{% endfor %}
</section>
{% endfor %}
