---
title: Diaries
description: "Selections from a diary. Patterns, ideas, gossip, writing notes, shopping lists, daydreams, fantasies."
abstract: "In the ninth grade, my classmates were shocked by the excessive candour of my MySpace blog posts. I published the truth of how I felt without considering the consequences. The diary that I publish today is an ongoing experiment in autofictional narrativization---a story based in memoir; an aestheticized residue of a process of living. Nothing here should be taken as 'true,' but everything is based in reality.


The writing on this page is influenced by New Narrative, online writing, diary writing, the autobiography, contemporary art and cinema, and cognitive behavioural therapy. *Here are the words that I have left on my page, and in them you will see---the very distance that lies between truth and fiction, between life and art!*"
toc: true
status: ongoing
date: 2020-07-31
redirect_to: /diaries
---

<blockquote class="epigraph" itemprop="citation">
I toss these pages in the faces of timid, furtive, respectable people and say: ‘There! that’s me! You may like it or lump it, but it’s true. And I challenge you to follow suit, to flash the searchlight of your self-consciousness into every remotest corner of your life and invite everybody’s inspection. Be candid, be honest, break down the partitions of your cubicle, come out of your burrow, little worm.’ As we are all such worms we should at least be honest worms.

[W.N.P Barbellion](https://en.wikipedia.org/wiki/W._N._P._Barbellion),_ [*Journal of a Disappointed Man*](https://www.pseudopodium.org/barbellionblog/books.html)

</blockquote>

<blockquote class="epigraph" itemprop="citation">
I IX (*1914*)---In complete helplessness wrote barely 2 pages. I have retreated considerably today, even though I had slept well. But I know that I must not yield, if I want to rise above the lowest woes of my writing, which is already held down by the rest of my way of life, into the greater freedom that might be waiting for me. The old dullness has not yet completely left me I realize and the coldness of my heart might never leave me. The fact that I recoil from no humiliation can just as well mean hopelessness as give hope.

--- [@kafka2022, 356]

</blockquote>

<blockquote class="epigraph" itemprop="citation">
You adulterate the truth as you write. There isn't any pretense that you try to arrive at the literal truth. And the only consolation when you confess to this flaw is that you are seeking to arrive at poetic truth, which can be reached only through fabrication, imagination, stylization. What I'm striving for is authenticity; none of it is real.

--- W. G. Sebald, quoted in [@shields2010, 62]

</blockquote>

<blockquote class="epigraph" itemprop="citation">
When she can't sleep at night, she tries to remember the details of all the rooms where she has slept...The objects that appear are always linked to gestures and singular facts...In those rooms, she never sees herself with the clarity of photos, but blurred as in a film on an encrypted TV channel...She doesn't know what she wants from these inventories, except maybe through the accumulation of memories of objects, to again become the person she was at such and such a time.

She would like to assemble these multiple images of herself, separate and discordant, thread them together with the story of her existence, starting with her birth during World War II up until the present day. Therefore, an existence that is singular but also merged with the movements of a generation. Each time she begins, she meets the same obstacles: how to represent the passage of historical time, the changing of things, ideas, and manners, and the private life of this woman? How to make the fresco of forty-five years coincide with the search for a self outside of History, the self of suspended moments transformed into the poems she wrote at twenty ("Solitude," etc.)? Her main concern is the choice between "I" and "she." There is something too permanent about "I," something shrunken and stifling, whereas "she" is too exterior and remote. The image she has of her book in its nonexistent form, of the impression it should leave, is...an image of light and shadow streaming over faces. But she hasn't yet discovered how to do this. She awaits if not a revelation, then a sign, a happenstance, as the madeleine dipped in tea was for Marcel Proust.

Even more than this book, the future is the next man who will make her dream, buy new clothes, and wait: for a letter, a phone call, a message on the answering machine.

--- Annie Ernaux, *The Years*, translated by Alison L. Strayer

</blockquote>

{% assign date_format = "%b %d %Y" %}

{% assign postsByYear = site.blog | sort | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear reversed %}
<section id="{{ year.name }}" class="level1">
<h1 id="{{ year.name }}"><a href="/blog#{{ year.name }}">{{ year.name }}</a></h1>
{% assign postsByMonth = year.items | sort | group_by_exp:"post", "post.date | date: '%B'" %}
{% for month in postsByMonth reversed %}
<section id="{{ year.name }}-{{ month.name | date: '%m' }}" class="level2">
<h2 id="{{ year.name }}-{{ month.name | date: '%m' }}">
	<a href="#{{ year.name }}-{{ month.name | date: '%m' }}">{{ month.name | date: '%B' }}</a>
</h2>
{% for post in month.items reversed %}
<section class="blog-post e-content level3" id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}" itemprop="blogPost" itemscope itemtype="http://schema.org/BlogPosting" itemid="https://umt.world/blog#{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}">
<div class="blog-post-header">
<h3 id="{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}" class="blog-post-date">
	<a href="#{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}" title="'{{ post.title }}', posted on {{ post.date | date: "%b %e, %Y." }}">
		<time class="dt-published" itemprop="datePublished" datetime="{{ post.date }}">{{ post.date | date: '%d (%a)' }}
	</a>
{% if post.title %}<span class="blog-post-title" itemprop="name">{{ post.title }}</span>{% endif %}
 		</time>
</h3>
{% if post.description %}<span class="blog-post-description" itemprop="description">{{ post.description }}</span>{% endif %}

</div>

<span itemprop="articleBody">
{{ post.content }}
</span>

{% if post.last_modified_at %}<span class="blog-post-modified-date">Last edited <a href="{{ site.github.repository_url }}/blob/main/collections/_blog/{{ year.name }}-{{ month.name | date: '%m' }}-{{ post.date | date: '%d' }}.md">{{ post.last_modified_at | date: date_format }}</a></span>{% endif %}

</section>
{% endfor %}
</section>
{% endfor %}
</section>
{% endfor %}
