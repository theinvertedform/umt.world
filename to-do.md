---
title: umt.world Development Plan
description: A never-ending roadmap to success.
published: true
toc: true
permalink: to-do
---

# Content System

## Backlinks
* Each section within a page gets its own backlinks section
* A page only gets a backlinks section if there is a link to that page's base URL
	* Bug: pages appear in its own backlinks section when it contains a link to itself
* Context should be the surrounding paragraph to a max of 250 words equally distributed on either side of the link, cut off at the nearest sentence.
* Context should preserve formatting, including links
	* What about footnotes?
* Format should be as a list, with the Title of the page as a hyperlink, and an optional (full context) parenthetical linking to the sub-section
* The content of the backlink should appear in a blockquote
* Skip adding backlinks to binaries or links that are not contained on the root domain
* The plugin is also generating the section in the HTML even if there are no items to populate it
* Requires an automated build script with development and deployment options

## Tagging System
* Tag can be applied to posts, diary entries, documents, or links
* Individual tag pages

## Metadata & References
* Bibliography, Footnotes, Backlinks, Similar Links sections in the TOC
	* Only if the items exist
	* Footnotes section gets a graphic element
* Bibliography item styling
* Bibliographic items should automatically have a link to the archived item
* "Similar Links" section
	* Based on tagging
	* We will eventually need to just come up with our own CSL.
* Modify the CSL so that each reference points to an item included

# Film Management

## Film Section Organization
* We need a better structure and organization method for the Film section
	* https://umt.world/films
		* https://umt.world/films/flight-risk-2025/ - Every film in the database gets its own landing page, where we can group metadata, my reviews, log entries, bibentries that reference it, and backlinks to any other references to it
		* https://umt.world/films#favourites - Top Four front-and-centre
		* https://umt.world/films#criticism - Section that highlights long-form film writing
		* https://umt.world/films#lists / https://umt.world/films/lists - Section that highlights Lists
		* https://umt.world/films#diary / https://umt.world/films/diary - Film Diary entries (logged films), along with Reviews if applicable
		* https://umt.world/films/all (?) - Database of all films

# Navigation & Interface

## TOC Enhancements
* Numbered levels that only show in larger viewports
* Background of entry is dark when hovered
* Little bar at the end of the highlighted line

## Section Headers
* Consistent use of the paragraph symbol for all levels
* Shows on hover with some opacity
* Stays when section is clicked with zero opacity (JS?)

## Link Annotations
* Annotations for different filetypes
* Annotations for newly-updated internal links

## Navigation Elements
* CSS icons
	* Favicons for external website
* Return to Top button
* Title of *Diary* entry should link to its anchor

# Visual Design & Typography

## Theme System
* Auto / light / dark mode

## Typography System
* The current system is too Art Deco. We want to move towards an eclectic style with industrial influences
	* Serif (body text): Caslon
	* Sans-serif: Neutraface Book
	* Display: Mrs. Eaves
	* Monospace: Courier New
* We need a serif typeface for headers that is
	* characterful
	* contains a full range of styles and weights
* Navbar needs more colour & movement
	* "Newsletter" and "Patreon" navbar items need colours
	* Maybe the outlines hover on movement
	* Newsletter CTA at bottom of page

## Visual Elements
* Unique list style types
* Set of ornaments
	* End mark
	* Section mark
	* Manicule
	* Fleurons
* Graphic divider for the Footnotes section
* Drop caps

## Code Styling
* Style code blocks
	* Custom syntax highlighting based on umt.world colourscheme

# Media & Content Presentation

## Image System
* Lightbox option for images
* Slideshow option for images

## Photos
* A new style of page organized around single photos and photo galleries
	* Design system based on Instagram
	* Tagging and linking system for photos
	* Pieces of visual culture, in addition to original photos
* System for full-width images that take up both margins

## Diaries Enhancement
* More multi-media in *Diaries* for more of a scrapbook design
* Since the project is psychogeographical, it could use a mapping system
* Git history and complete evolution of every unit of text
* Break the system with marginalia and eclectic fonts

# Content Publishing & Automation

## Build System
* Automated build script with development and deployment options

## Content Organization
* Create a better visual system to organize categories

## Changelog & History
* Group items in the Changelog under a single list item per category
* Changelog summary for ongoing projects: "Diary: +400 words, -200 words, 23% different."
* Changelog summary of changes per month: how many commits, changes in word count and LOC, new references, links, etc added

## Content Enrichment
* "Blogroll" section on the bottom of each page that selects a quote, pdf, link, image (?) for each day

# Marketing

* UTA Links
* Custom analytics metrics
* More prominent CTAs for people coming from external sources
* Visual system for OpenGraph images

# Technical Infrastructure
* ~~news.umt.world --- listmonk hosted on EC2 instance~~
	* Finalize SES setup
	* SNS subscriptions
		* ~~Bounce & complaint~~
			* Verify that Listmojo auto-unsubscribes
		* Delivery
		* ???
* umt.world --- migrate from Netlify to S3 bucket
	* CloudFlare CDN, DDoS protection
	* Migrate DNS to CloudFlare
	* Move domain registration to Route 53

## Newsletter
* Email templates and pages with styling to match umt.world
	* https://news.umt.world --- Landing \& subscription page
	* https://umt.world/newsletter --- Newsletter archive page
	* https://umt.world/newsletter/:month/:day --- Pages for individual newsletters

# Completed Tasks
* ~~Re-structure the diary into chronological chapters~~
	* How does the voice of the *Diaries* relate to the voice used throughout the website?
* ~~Add a link to page commit history in metadata~~
	* Doesn't add anything since putting collections in a submodule; there should still be some way to see the history of published files on github
* ~~"Last revised" parenthetical on diary entries with link to commit history~~
* ~~Sidenotes~~
	* Currently has some bugs relating to re-drawing sn to fn when resizing the viewport
* ~~Section headers should link to their anchor~~
* ~~Style image borders, add shadows~~
* ~~Graphic to separate section clusters~~
* ~~Change sidebar to top-style navbar~~
* ~~New logo~~
* ~~Footer, giving a better visual break from the page~~
* ~~Justified text with automatic hyphenation~~
	* No more than two annotations in a row
	* 3 characters before hyphen
	* No rivers
* ~~Responsive text size~~
