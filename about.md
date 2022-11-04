---
title: About
description: A page about this website. What gets collected here; what are the methods and aspirations.
abstract: This is an about page for the website, with details on the design inspiration and the ambition of its breadth.
layout: meta
toc: true
---

As technical literacy decreases in inverse proportion to our society's increased reliance on the internet, it becomes ever more urgent to retain independent control of one's content online. What follows is a comprehensive program for a Web-based self-publishing platform. At its heart is a website that functions as a single corpus, a statically-generated *Weltanschauung*. Connecting this work to the social web are two avenues of communication: a newsletter, and automated syndication across social media. The technical implementation of an integrated writing environment and publishing platform enables a form of writing whose distinct literary form is untouched by the article-form of traditional publishing. Over the past six consecutive years, I have been developing a writing environment that I hope to unify and organize into a single work that is both software and writing. This project involves the design and technical implementation of a complete archival system. 

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

A core element of this publishing strategy is a political desire to retain independent control of my work. However, given that my work is conceptual and relies on context, my suspicion is that conventional SEO strategies will do little to generate discovery (this is an unverified claim; more research needs to be done). My goal is to develop a plugin for the SSG that automatically syndicates content across social media as part of the automated publication process. In order to promote engagement, relevant pieces of content will be posted across platforms (i.e. updates on Twitter, film reviews on Letterboxd, etc). Commenting and "calls to action" will be funnelled to external social media platforms in order to drive engagement.

The second element of my outreach program is a newsletter. This database, which must be hosted independently of commercial services like Substack or Mailchimp (a daunting technical challenge), represents a direct line of communication with my audience, and is therefore of great importance to the overall project. The newsletter is still roughly conceived. One idea is a "Culture Diary," a weekly/bi-weekly, informal log of my encounters with culture. The style/tone of writing and its position with respect to the website is still an open question. I may end up with two mailing lists: one unscheduled, used for promotional updates; another structured and posted on a schedule.
