---
title: About This Website
description: A page describing the technical, aesthetic, and political dimensions of umt.world. 
abstract: Including more details on what gets collected on this website, and what are the methods used for that collection; what are the design principles, inspirations, ambitions.
layout: meta
toc: true
tags:
  - umt.world
  - personal
  - web design
---

Through technical means, we can directly manipulate the material of new media. Unfortunately, since the onset of the digital age, untold resources have been poured directly into suppressing technical literacy. The evolution of the internet as a social mediator through handheld computer devices has created a digital economy that largely depends on compliant consumption, rather than creative use. Applications abstract away from technology, imprisoning pure mutability and aesthetic potential in graphical interfaces---limited frameworks confined to another's vision. The challenge is to fight for our own use of new media on our own terms; rather than using other peoples' platforms, confining our aesthetic works within the horizon of FAANG allows us to claim the internet, the dominant social medium, and use technical means for our own aesthetic ends. What follows is a comprehensive program for a Web-based self-publishing platform. At its heart is a website that functions as a single corpus, a statically-generated *Weltanschauung*. Connecting this work to the social web are two avenues of communication: a newsletter, and automated syndication across social media. The technical implementation of an integrated writing environment and publishing platform enables a form of writing whose distinct literary form is untouched by the article-form of traditional publishing. Over the past six consecutive years, I have been developing a writing environment that I hope to unify and organize into a single work that is both software and writing. This project involves the design and technical implementation of a complete archival system. 

The structure and contents of the proposed website mirror the writer's personal archive. Updates and revisions are automatically scheduled, and changes are tracked and accessible. Pages grow over time, repositories of information and references on a topic and organized into sections. Together, the hyperlinked topics, sections, and resources together all represent an articulation of thought that grows over the course of a lifetime.

# Structure

* umt.world/index --- Category-organized index page; min-width columnar lists of up to ~15 titles per category
- umt.world/changes --- Updates and changelog page:
	* Technical implementation depends on the version control system (VCS) used. The general idea is a summary of changes to the website; short, uncategorised posts: as well as a log of achievements, publications, and notable activity. A cross between a changelog and a blog, a single long page with posts under yearly / monthly headings.
* umt.world/about --- About page with practitioner's statement, followed by a longer essay on the content and form of writing found on the website; notes on design.
* umt.world/links --- Links page with information on technical features of my tools and processes (computer, OS, writing environment, archival practises, writing habits, lifestyle, other hobbies, etc), as well as external links.
* umt.world/{page} --- (for long-term stability, each page should have a one word URL)
	* Page header metadata in proposed order of appearance:
		* index page category ("Art Criticism", "Film Criticism", "Philosophy", "Communist Theory")
		* Page title
		* Date posted / date updated (how to implement a revision history TBD)
		* tags, based on a set of archival standards (e.g. MARC Standards)
		* 1 sentence description (used for social media posts)
		* abstract
		* table of contents
	* Page footer:
		* link to guestbook (anonymous, general feedback)
		* link to the page's canonical social media posts (redirect commenting to social media, generating algorithmic engagement)

# Content

My writing practise includes critical writing, research, and fiction. The first depends on a constant, renewed encounter with primary works. My research into the history of film and art is centred around the concept of the avant-garde. My philosophical research into debates on the relationship between art and society. debates in the history of film and art, as well as engagement with philosophy. second involves works primarily represented on this website.

* Research-based content
	* umt.world/marxism --- Collecting everything I know about Marxism (sections: "value", "commodity fetishism", "metabolic rift", etc). Annotated bibliography.
	* umt.world/masson --- All of my research into the Surrealist painter Andre Masson ("Relationship with Lacan", "Independent invention of automatism", "Nietzschean influence").
	* umt.world/surrealism --- Everything I know about Surrealism ("Bresson vs. Bataille", "Automatism", "communism").
* Critical content
	* umt.world/films#{movie-title} --- Writing about films is a big part of my writing practise. Online organization is still under development. I am currently trying to reconcile having a canonical review that is edited; or a more diaristic format, where impressions are recorded on each viewing, preserved as the record of an impression, and multiplied on each additional viewing of the film. Refer also to "Newsletter" and "Cross-posting" sections below.
	* umt.world/{venue}#{show} --- Reviews of art shows is another important part of my practise. Online organization of this practise is under development. The current idea is to use the venue as the main one word page, with some introductory / non-review writing on the architecture, curatorial direction, history, etc; the page will be separated into sections for the individual show or item(s) in the permanent collection that I am writing about. Example: umt.world/mac#points-of-light for my review of the show *Points of Light* (2020) at the Musée d'art contemporain (MAC).
	* umt.world/books#{book-title} --- Book reviews will (most likely) be treated in a similar way to films. Refer also to "Newsletter" and "Cross-posting" sections below.

# Outreach

A core element of this publishing strategy is a political desire to retain independent control of my work. However, given that my work is conceptual and relies on context, my suspicion is that conventional SEO strategies will do little to generate discovery (this is an unverified claim; more research needs to be done). My goal is to develop a plugin for the SSG that automatically syndicates content across social media as part of the automated publication process. In order to promote engagement, relevant pieces of content will be posted across platforms (i.e. updates on Twitter, film reviews on Letterboxd, etc). Commenting and "calls to action" will be funnelled to external social media platforms in order to drive discoverability.

The second element of my outreach program is a newsletter. This database, which must be hosted independently of commercial services like Substack or Mailchimp (a daunting technical challenge), represents a direct line of communication with my audience, and is therefore of great importance to the overall project. The newsletter is still roughly conceived. One idea is a "Culture Diary," a weekly/bi-weekly, informal log of my encounters with culture. However, I feel like this may be too ambitious, and I might be better off simply using the very simple form of categorized lists. The style/tone of writing and its position with respect to the website is still an open question. I may end up with two mailing lists: one unscheduled, used for promotional updates; another structured and posted on a schedule.

# To do

## Structural

* Blog logic and changelog page integration. Misc blog posts, almost always short form, should be added to the top of a single blog file and displayed alongside automated updates, on the [changelog](/changelog) page. In order to integrate git changes into the changelog, we will need to start scripting the publishing process.

* The *Footnotes to Endnotes* podcast needs to be one page, which subsections for new episodes, listed in chronological order. We need external hosting for the podcast files now that we have moved to netlify's free hosting.

* Tag and category page anchors do not currently work. They also need to be alphabetized. There's more that can be done with tagging and categorizing, but that's also a quite daunting task.

* Citation is not set up at all. Jekyll has historically resisted integration with Pandoc, but we will need to figure out how it's going to work on the back-end---but also how it's going to work on the front-end, in terms of CSS design, anchor links, etc etc (this is not even addressing side-notes).

* Reviews section on index page has subsections with second-order lists. Section will need to be arbitrary length. Directory structure: collections/reviews/{film,books}#{exhibition}

The question still remains how to organize art reviews. It's difficult to standardize reviews that cover multiple artists. The best options seem to be to either group them under the heading of a column; or to organize shows seen in person under the title of a location. There's no way to standardize art reviews. However, there might be a way to do it through some bibliographic approach---but I don't know enough. There needs to be a way to do random pieces of writing. They won't be that long. I think it's best to just keep shows to a location.

Reviews
  Film Reviews
    Triangle of Sadness (2022)
	Damnation (1988)
	The Matrix (1999)
  Art
    Diane Arbus at the MBAM
	Basquiat at the MBAM
	Mikka Rottenberg at the MAC
  Books
    Thus Spoke Zarathustra by Friedrich Nietzsche
	Absalom, Absalom by William Faulkner
	Orlando by Virginia Woolf

## Design

* Style header text (smallcaps, weight, size, spacing)
* Section header links
* Offset headers by 1
* Centre footer element, add a bit of spacing
* Font size and line spacing settings for the different viewport sizes
* Three column wide screen index page
* Page content centred / somewhat right-aligned
* Clean up the logo
* Indent non-leading paragraphs, no line breaks.
* Style and indent lists
* Style for epigraphs
* Style for code (inline and block)
* Style endnotes and bibliography
