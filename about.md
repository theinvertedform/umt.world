---
title: About This Website
description: An artistic manifesto. Theorization, technical implementation, and road-mapping. 
abstract: "This website is conceived of as a hypermedia literary experiment. It begins with my writing environment and its technical implementation; it includes the design and architecture of this website; and finally, the *website-as-a-work-of-art* involves literary forms that are themselves experimental. This page is 'meta-fictional' in the sense that it covers the technical and theoretical background informing the project. It also treats the political issues that motivate my interest in hypermedia and digital culture. Some of the relevant topics include: the avant-garde, outsider culture, and institutional critique. The ultimate objective of this website is to combine interface design, web design, and literary form to create a new kind of book, at once memoir and socially-committed cultural critique."
toc: true
tags:
  - outsider art
  - avant-garde
  - new media
  - hypermedia
  - web design
  - graphic design
  - typography
  - experimental literature
  - archival systems
  - library sciences
status: extremely rough
date: 2022-09-11
---

When John Anderton goes on the lam in *Minority Report*, he undergoes surgery to replace his eyes because of the omnipresent retinal scanner. A similar level of surveillance has been achieved, but it depends more on the mediation of digital platforms than on external scanners. Virtual life has become an *a priori* for those born in the Internet Age. 

Alienation before the behemoth pushes Spirit down to the pre-unhappy position of Stoicism. There is mass desire for the ether of *ataraxia*. Technical optimization smoothes so much of daily life. Digital culture and all its social potential has been confined to a protocol strictly controlled by capital. Tech conglomerates and hardware manufacturers have more power than states, but without the hindrance of historical precedent.

![Wipe Cycle](/assets/images/wipe_cycle.jpg)

And yet---life has always been mediated by technology. The record of civilization going back to the first cave paintings in 35,000 BCE is the unfolding of the process of society's relationship to technology. How do we evaluate our present dependence without falling into the trap of thinking that the past was somehow better? Are we on a natural path to cyborg transhumanism? Is Spirit doomed to self-alienation? No matter what, we should not convict the fallacy that Hume identified so well: *correlation does not equal causation* [@hume1995]. The fact of technology does not mean that all technologies are good.

# Origins of Language and the Graphic Arts

The thing is attached to society like a parasite. The fact that technology has always existed in some form, everywhere, is a strong argument for its necessary relation to society. However, this tells us nothing about the forms of technology we live with today. For those for whom the Digital Age is *a posteriori*, it may be easy to see it is just another product sold to the proletariat against its own interests. But how do we remain progressive, while acknowledging decline?

!["Cave paintings are the origin of graphic design. They represent a "technology" in the sense that they are accomplished by means of a tool to join two separate things. Tablets are especially important in the history of art-as-technology, in my view, because they represent the invention of a new medium of art through the synthesis of two previously separate entities" [@meggs2012, 11].](/assets/images/blau.png)

For years now I have been engrossed in developing my competency with the tools and systems of software development. It started when I was 16, and installed Slackware on the first PC I ever bought for myself. During my post-secondary studies, I procrastinated writing essays by learning vim, "a highly configurable text editor built to make creating and changing any kind of text very efficient." [^1] The text editor is the writer's hand-tool, like the carpenter's chisel. It opened me up to a whole new technological ecosystem that has come together as something more than an accidental element of my writing.

I do not claim more than a minimum degree of technical literacy acquired through my hobby of systems administration; and from using vim alongside things like dwm and associated suckless utilities to design my own desktop environment; Git (a version control system); LaTeX/Pandoc markdown (a typesetting programming language and interpreter); and Jekyll (a static website generator). This hobby is an entire practise obviously quite distant from an education in the humanities. My personally-configured computer system is the writing implement of a new media-based literary practise. I am a cyber-skeptic at heart, but one who is strongly drawn to technical computer work. My use of computers is *aesthetic*.

[^1]: “Vim - the Ubiquitous Text Editor.” welcome home : vim online. Accessed June 3, 2024. https://www.vim.org/.

# Writing on the Internet

My writing practise includes critical writing, research, and fiction. The genre of fiction that I am most interested in is "experimental biography." The writing that will be published on this website are original essays that relate directly to the topic of hypertext and hypermedia; the diaries themselves; and it will also be an archive of the newsletter, changelog, and writing published elsewhere.

I'm interested in self-published writing online as a form of outsider art, but I am not absolutely committed to it. I will still be publishing writing elsewhere. An artist needs to build an audience, after all.

![Abolish the Internet!](/assets/images/steyerl2.jpg)

The rough idea for the [newsletter](/news) is to use it to collect additions to a notes archive. Notes in the note-taking system are always based on a primary source, have commentary, and are already grouped under category headings. Periodically send out an update with quotes, ideas, links, images, aphorisms, and edit summaries. The introductory paragraph is just something that summarizes what the collection of notes represents.

# The Design of Online Writing

The writing lives as an ongoing process, a constantly-refined collection of citations, quotes, hyperlinks, and cross-references. The structure of pages changes and morphs, breaking open the borders of the website. Notes become essays, grouped under sections around a topic. HTML document structure, CSS, the algorithms of the website generator, the version control system, the writing environment, and finally the content of the words and where it stands in relation to the centre. These elements of literary content and new media combine to make the website an original work of art, a hybrid between the literary and the visual.

The structure and contents of the proposed website, the published face of the project, mirrors the writer's personal archive of visual and textual material. Drafts, fragments, notes, revisions, photographs, visual material: a collection of rags [^2]. Updates and revisions are scheduled, and changes are tracked and logged. Together, the work represents an articulation of thought that grows over the course of a lifetime. At the same time, it builds its own documentary foundation.

[^2]: "'Here we have a man whose job it is to gather the day’s refuse in the capital. Everything that the big city has thrown away, everything it has lost, everything it has scorned, everything it has crushed underfoot he catalogues and collects. He collates the annals of intemperance, the capharnaum of waste. He sorts things out and selects judiciously: he collects like a miser like a miser guarding a treasure, refuse which will assume the shape of useful or gratifying objects between the jaws of the goddess of Industry.' This description is one extended metaphor for the poetic method, as Baudelaire practiced it. Ragpicker and poet: both are concerned with refuse." [@benjamin1938, 48]

## Aesthetic Elements of Hypertext

1. URL Schema

[Cosma's website](http://bactra.org/) has many pages, but the URLs are all quite schematic. To my mind, they clash with what we expect from websites nowadays. Incongruous URLs produce a certain effect, but I like Gwern's approach of single-word URLs. Social media was not a concern for older Web pioneers. Now we must prioritize short, stable URLs.

2. Page Structure

One of the classic things that hypertext theorists love to talk about is linking. In many case studies of hypertextual works, pages tend to be designed for a single viewport. In contrast to this, Gwern's website is structured around "long" pages. The idea here is to create sections that can be linked to. The problem here is that style tends to gravitate towards singular works. Sub-sectioning is challenging to pull off when we're going for something "literary,", but it's an important part of creating linkable units. Linking is what makes the website a real work of art.

3. Metadata

Like the URL, metadata is another element that is both aesthetic and technical, and which sits at the core of the website as a hypertext artwork. We want to think up metadata categories that can be used to represent the important aspects of a page. They will need to be standardized, somehow.


# References
