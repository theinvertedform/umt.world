---
title: About the Website
description: A page describing the aesthetic goals, content, and technical implementation of umt.world. 
abstract: A short essay about new media and literature. Schematic lists on how the URLs should be structured; methods used for that collection; the design principles, inspirations, ambitions.
layout: meta
toc: true
tags:
  - umt.world
  - personal
  - web design
  - new media
status: active development
---

Technical literacy worsens even as digital life grows. Technological mediation is fundamental to the dominant culture among people born into the digital age, but it has always been the comprehensive effort of the fatcats in charge to carefully restrict the public's knowledge of and access to the technology they take for granted. Digital culture and all its social potential has been confined to a set of terms strictly delineated by the ruling class. Tech conglomerates and hardware manufacturers have more power than states, but without the encumbrance of needing to represent a national identity. Digital life doesn't exist without personal computers and platform monopolies---without generating profit for the ruling class, even as they viciously exploit the earth.

What follows is a comprehensive program for a web-based self-publishing platform. For years now I have been engrossed in the attempt to use the tools and systems of software development in service of a literary project. It started with learning vim, "a highly configurable text editor built to make creating and changing any kind of text very efficient." The editor is a hand-tool that opened me up to a whole new technological ecosystem that is gradually coming together as more than an accidental element of my writing. I would not claim more than the minimum, being technically literate due to the practise of systems administration; and from of using vim alongside things like Git (a version control system); LaTeX/Pandoc markdown (a typesetting programming language and interpreter); and Jekyll (a static website generator), an entire practise that is not discussed in the humanities. My personally-configured computer system is the writing implement of a new media-based literary practise. I am a cyber-skeptic at heart, but one who is strongly drawn to technical computer work. My use of computers is *aesthetic*.

# Form of the website

The published form of the archive functions as a single corpus, added to and refined over time. The writing lives as an ongoing process, an accretion of citations, quotes, hyperlinks, and cross-references. Notes become essays, grouped under sections around a topic. Topics are themselves categorized at the top level, an index tracing where my interests are grouped. HTML document structure, CSS, the algorithms of the website generator, the version control system, and the writing environment itself are a synthesis of archive (literary content) and new media (technical implementation). It makes possible a form of writing that is appropriate to the digital culture of new media. Articles and essays are all well and good, but they don't take advantage of what is made possible in the presentation of text online. (This website is itself in an early stage of development, but it has its shape.)

The structure and contents of the proposed website, the published face of the project, mirrors the writer's personal archive of visual and textual material. Drafts, fragments, notes, revisions, photographs, visual material, a Benjaminian collection of rags [^1]. Updates and revisions are scheduled, and changes are tracked and logged. Together, the work represents an articulation of thought that grows over the course of a lifetime.

[^1]: "'Here we have a man whose job it is to gather the day’s refuse in the capital. Everything that the big city has thrown away, everything it has lost, everything it has scorned, everything it has crushed underfoot he catalogues and collects. He collates the annals of intemperance, the capharnaum of waste. He sorts things out and selects judiciously: he collects like a miser like a miser guarding a treasure, refuse which will assume the shape of useful or gratifying objects between the jaws of the goddess of Industry.' This description is one extended metaphor for the poetic method, as Baudelaire practiced it. Ragpicker and poet: both are concerned with refuse." [@benjamin1938, 48]

## URL Schema, Page Structure & Metadata

The archive is made up of textual units, all of whose location and content are in flux. However, the URL schema must be absolutely rigid. Preference for single words. Subsections of the page might be re-located, but URLs must be stable; page structure and cross-referencing will get the reader where they need to go, in the event that information moves around.

* umt.world/index --- Category-organized index page; min-width columnar lists up to ~15 titles per category
- umt.world/changes --- Summary of updates and additions to the website (content as well as source code)
* umt.world/about --- About the website, followed by a longer essay giving some background on its contents; notes on design and implementation; any statistical data
* umt.world/links --- About the author; information on technical features of my tools and processes (computer, OS, writing environment, archival practises, writing habits, interests, hobbies); links to social media; surveys; psychological, typographic, evaluative profiles.
* umt.world/{page} --- (for long-term stability, each page should have a one word URL)
	* Page header metadata in proposed order of appearance:
		* page title
		* date posted / date updated (revision history ongoing)
		* tags, based on some set of archival standards
		* 1 sentence description (used for social media posts)
		* abstract
		* table of contents
		* status: ongoing / rough draft / nothing yet / fever dream
	* Page footer:
		* link to the page's canonical social media posts (redirect commenting to social media to promote engagement)
		* link to guestbook (anonymous, general feedback)
* umt.world/films#{movie-title} --- Writing about films is a constant part of my writing practise. Implementation is still under development. I am also undecided about the form of writing about films: whether to try to write canonical "reviews," or a more impressionistic column, which seems to be more popular these days. Refer also to "Newsletter" and "Cross-posting" sections below.
* umt.world/{venue}#{show} --- Reviews of art shows is another important part of my practise. Online organization of these are also under development. The question is how to synthesize a non-formulaic title with stable URLs. The current idea is to use the venue as the main one-word page, which would therefore allow space for extended writing on the institution; the page will be separated into sections for the individual show or item(s) in the permanent collection that I am writing about. Example: umt.world/mac#points-of-light for my review of the show *Points of Light* (2020) at the Musée d'art contemporain (MAC).
* umt.world/books#{book-title} --- Book reviews will (most likely) be treated in a similar way to films. Refer also to "Newsletter" and "Cross-posting" sections below.


## Content of the website

My writing practise includes critical writing, research, and fiction. The last is conceived of as belonging to traditional publishing, and as of yet is only a part of the website project through what influence it may have on my style. The first depends on a constant, renewed encounter with primary works, which itself is a pragmatic reminder to avoid settling into a scholarly mindset. I am interested in the political--economic character expressed in culture. My research into the history of art is the case-work of my philosophical research into the relationship between art and society. I follow an intuition that there is an avenue through culture for the optimism of the revolutionary. 

I am always interested in critical modernism, as well as the precursors to digital aesthetics that I have found in conceptual art and video work. I have a major interest in new media, and am working to develop an historical materialist understanding of digital culture, or the technologically-mediated, neurotically-reinforced visual paradigm. My literary interests are in writers who move between philosophy and fiction. Dostoyevsky, Bolano, and Thomas Mann represent the height of what I have seen in literature; their accomplishment depends critically on the depth of their philosophical feeling. Nietzsche and Kierkegaard were two formative writers who showed me that it was also possible to move in the opposite direction, using literary devices in service of the medium of thought. I am interested in writers whose style shifts between philosophy and narrative, a diaristic first-person and literary narration; writers like W.G. Sebald, Maggie Nelson, Ben Lerner, and Jean-Jacques Rousseau.

* Research-based content
	* umt.world/marxism --- Collecting everything I know about Marxism (sections: "value", "commodity fetishism", "metabolic rift", etc). Annotated bibliography.
	* umt.world/masson --- All of my research into the Surrealist painter Andre Masson ("Relationship with Lacan", "Independent invention of automatism", "Nietzschean influence").
	* umt.world/surrealism --- Everything I know about Surrealism ("Bresson vs. Bataille", "Automatism", "communism").
* Critical content
	* umt.world/films#{movie-title} --- Writing about films is a big part of my writing practise. Online organization is still under development. I am currently trying to reconcile having a canonical review that is edited; or a more diaristic format, where impressions are recorded on each viewing, preserved as the record of an impression, and multiplied on each additional viewing of the film. Refer also to "Newsletter" and "Cross-posting" sections below.
	* umt.world/{venue}#{show} --- Reviews of art shows is another important part of my practise. Online organization of this practise is under development. The current idea is to use the venue as the main one word page, with some introductory / non-review writing on the architecture, curatorial direction, history, etc; the page will be separated into sections for the individual show or item(s) in the permanent collection that I am writing about. Example: umt.world/mac#points-of-light for my review of the show *Points of Light* (2020) at the Musée d'art contemporain (MAC).
	* umt.world/books#{book-title} --- Book reviews will (most likely) be treated in a similar way to films. Refer also to "Newsletter" and "Cross-posting" sections below.

## Outreach Plugins

The project that I have described has a political valence that need not be overstated. It is true that technical literacy is poor, especially relative to how popular technology is. It is non-trivial that the proletariat is exploited in virtue of its subjectively-gratifying relationship to technology; however, one artist combining their writing practise with a contingent aesthetic attraction to computer systems is not politically important. My own feelings on the matter are that the entire digital social structure ought to be abolished. The pragmatism of controlling the centre of one's existence online is especially relevant, given the present instability of the platforms we might have once taken for granted. However, a website still needs to be connected to the web. An essential aspect of the project is pre-formatted syndication across social media platforms using a plugin system. Pieces of code can be added to the website that will allow for either scraping content from an external source (i.e. film reviews from Letterboxd), or posting content to social media automatically. The goal is to collect statistical data that will help me maximize an instrumental use of social media. This will not be enough to drive engagement absent my own meaningful participation in any online networks, but it's something to start with.

The second element of my outreach program is the newsletter. This database of email addresses will represent a direct line of communication with people who have double-consented to hearing from me. It is of great importance to the overall strategy, and represents a substantial technical and formal challenge. The rough idea is to use it to collect additions to the archive. Periodically I will send out an update of quotes, theses, links, images, aphorisms, and refactorings. The items are all grouped under categorical headings, with some brief commentary on their place in the overall system.

# To do

## Programmatic

* Blog page
	* ~~single page with anchor links,~~ ~~post metadata class,~~ description inline with date, add spacing to bottom of tags
	* Automatic date:time for posts
	* Automatic modified time for posts
	* Chronological TOC that still has room for post titles.
	* Automatically-generated metadata that situates me in the environment. "Posted from {location profile}, {weather description}." The date should include the time and the amount of hours:minutes spent writing the post.
	* If a post is over a certain length, it gets a collapsible frame. If text up to first section break is less than the max text length, show it; otherwise, show text up to the max text length.
* Changelog page
	* Integrate with the git log.
	* Category links don't work.
	* Add descriptions as well as abstracts.
	* We may want to add events to the log, e.g. to mark a calendar event, without needing to write a blog post?
* Permalink for collections
	* Need to be able to insert links to collection URLs (e.g. on the changelog page), whether they have a page or just an anchor link on the index.
* ~~*Footnotes to Endnotes* podcast single page.~~ 
	* External hosting for podcast files. Links need to be programmatically inserted (AWK).
	* Bug: shows first 10 episodes in index, rather than most recent 10.
	* Remove "episode" from title, add to metadata; number the episodes consecutively(?)
* ~~Tag and category pages.~~ They work the same as any other collection.
	* Bug: tags from "meta" files (non-collections) not added to tag index.
	* Category page currently non-functional.
* RSS Feeds
	* Changelog, podcast, blog
* ~~Pandoc~~
	* Style footnote links
	* Automatic bibliography section
* Reviews section on index page 
	* Subsections with second-order lists. Arbitrary length.
* Photo section
	* subdomain linked in sidebar: photos.umt.world
	* oriented around a general archive; galleries; and an ongoing photo project
	* a repository for visual media generally, not just photos
	* commenting
	* AI-generated tagging

Walter Benjamin's reviews did not follow a standardized format; he didn't write "columns" (although I'm sure he would have, given the opportunity). Art reviews do not easily lend themselves to standardization; film reviews do. Review objects are separated by their medium/tradition; shows, gallery/museum visits, or architectural explorations will simply by put under "art."

* Reviews
	* Film Reviews
		* Triangle of Sadness (2022)
		* Damnation (1988)
		* The Matrix (1999)
	* Art
		* *Trajectory of an Exhibition* at the Ellen Gallery
		* *Points of Light* at the MAC
		* Zia Anger's Cinematic Performance at the Beginning of the Pandemic
	* Books
		* *Thus Spoke Zarathustra* by Friedrich Nietzsche
		* *Absalom, Absalom!* by William Faulkner
		* *Orlando* by Virginia Woolf

## Design

* Style header text (~~smallcaps,~~ ~~weight,~~ ~~size,~~ ~~spacing~~, right side alignment)
* Add links to section headers
* Add an icon to section header
* Offset headers by 1
* Footer element: ~~centre,~~ graphic, spacing
* Font and line spacing settings for the different viewport sizes
* Three column wide screen index page
* Page content centred with slight rightward bias
* Clean up the logo
* ~~Indent non-leading paragraphs, no line breaks~~
* Lists: ~~indent,~~ custom bullet item
* Epigraphs: ~~emph text,~~ quotation graphics, pandoc syntax
* Style for code (inline and block)
* Block quotes? Are they different from epigraphs?
* Author-date citation format, but style the quotes so they're less disruptive to the text flow?

## Proposed Research Topics

* Philosophy
	* The Philosophy of Karl Marx
		* Atomistic Cosmology
		* The metabolic rift
		* Aesthetics
	* Hegel's *Phenomenology of Spirit*
	* Glissant
		* New media / *informatique*
	* Walter Benjamin
		* Dialectical image
		* Historical materialism
		* New media / material cultures
	* Adorno
		* Dialectical image
		* Modernity
	* Foucault
		* Genealogical method
		* Foucault and Nietzsche
		* Philosophy of history
	* Nietzsche
		* Will to power
	* Kierkegaard
		* The Authorship
		* Repetition
	* Kant
		* The Educational Benefits of Studying Kant
		* Onset of the Anthropocene?

* Art History
	* Realism
		* Courbet
	* Surrealism
		* Breton vs Bataille
		* Masson
		* *Nadja*
		* Alleged communism
	* Picasso's communism
	* Lettrism
	* Situationist International
	* Art & Language
	* Socialist Realism in USSR
	* Socialist Realism in China

* Film History
	* Film Noir
	* The French New Wave
		* Mainstream Canon
		* Alternative Canon
	* New German Cinema
	* Cinematic Modernism
	* Hollywood is God
	* Béla Tarr
	* Jean-Luc Godard: The Complete Oeuvre
	* Pier Paolo Pasolini's Communism
	* Fassbinder's relationship to socialism
	* Lucrecia Martel
	* Scripted project: generate year lists with every film viewed, and start sorting them.

* Journalism
	* The story of Lufa Farms
	* Concordia's Art History Department
	* Existentialism and Men
	* Corresponding Toxicities in Nietzsche and Kierkegaard

# Bibliography
