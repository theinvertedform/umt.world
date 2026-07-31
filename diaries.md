---
title: Diaries
description: "The way to be transgressive is to confuse the boundaries between who you are and who you perform as."
abstract: "In the ninth grade, my classmates were shocked by the excessive candour of my MySpace blog posts. I published the truth of how I felt without considering the consequences. The diary that I publish today is an ongoing experiment in autofictional narrativization---a story based in memoir; an aestheticized residue of a process of living. Nothing here should be taken as 'true,' but everything is based in reality."
toc: true
toc_max_level: 2
status: ongoing
date: 2023-09-01
dropcap: section
---

:::{.epigraph}
> I toss these pages in the faces of timid, furtive, respectable people and say: ‘There! that’s me! You may like it or lump it, but it’s true. And I challenge you to follow suit, to flash the searchlight of your self-consciousness into every remotest corner of your life and invite everybody’s inspection. Be candid, be honest, break down the partitions of your cubicle, come out of your burrow, little worm.’ As we are all such worms we should at least be honest worms.
>
> [@barbellion1919](https://www.pseudopodium.org/barbellionblog/books.html)
:::

{% assign date_format = "%b %d %Y" %}

{% assign chapters = site.diaries | sort: 'date' %}

{% for chapter in chapters %}

{{ chapter.content }}

{% endfor %}


