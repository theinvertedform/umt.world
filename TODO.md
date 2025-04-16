---
title: umt.world Development Plan
description: A never-ending roadmap to success.
published: true
toc: true
permalink: to-do
---

# High Priority

## Core Functionality

- Backlinks
	- Each section within a page should get its own backlinks section
	- A page only gets a backlinks section if there is a link to that page's base URL
	- We currently have the issue of a page appearing as a backlink when it contains a link to itself
		- A link on a page should only appear as a backlink for the base URL within the subsection it links to
	- Context should be the surrounding paragraph up to a max of 250 words, at which point it should cut off at the nearest sentence
	- Context should preserve formatting, including links
	- Format should be as a list, with the Title of the page as a hyperlink, and an optional (full context) parenthetical linking to the sub-section
	- The content of the backlink should appear in a blockquote
	- Skip adding backlinks to binaries or links that are not contained on the root domain
	- The plugin is also generating the section in the HTML even if there are no items to populate it
- Bibliography, Footnotes, Backlinks sections linked to in TOC
	- Only if the items exist
	- Automatically included in the TOC
- Tagging system
	- A tag can be applied to a post, a diary entry, a document, or a link
	- Individual tag posts

## Content Organization

- We need a better structure and organization method for the Film section
	- https://umt.world/films
		- https://umt.world/films/flight-risk-2025/ - Every film in the database gets its own landing page, where we can group metadata, my reviews, log entries, bibentries that reference it, and backlinks to any other references to it
		- https://umt.world/films#favourites - Top Four front-and-centre
		- https://umt.world/films#criticism - Section that highlights long-form film writing
		- https://umt.world/films#lists / https://umt.world/films/lists - Section that highlights Lists
		- https://umt.world/films#diary / https://umt.world/films/diary - Film Diary entries (logged films), along with Reviews if applicable
		- https://umt.world/films/all (?) - Database of all films

## Design Improvements

* Consistent use of the paragraph sign for headers; only shows on hover; stays when section is clicked (JS solution?)
- Unique list style types
- Auto / light / dark mode

# Medium Priority

## Visual Enhancements

- Typographic style + links for all references
- Lightbox option for images
- Slideshow option for images
- More multi-media in *Diaries* for more of a scrapbook design
- Create a better visual system to organize categories
- Better visual system for items in the Bibliography section
- Modify the CSL so that each reference points to an item included

## Navigation Improvements

- Link annotations
	- Favicons for external website
	- Annotations for different filetypes
	- Annotations for newly-updated internal links
- Return to Top button
- "Similar Posts" section linked to in TOC
	- Similar Links based on tagging
- Title of *Diary* entry should link to its anchor

# Long-term

## Content Enrichment

- "Blogroll" section on the bottom of each page that selects a quote, pdf, link, or whatever for each day
- Group items together under a single list item per category
- Changelog summary for ongoing projects: "Diary: +400 words, -200 words, 23% different."
- Changelog summary of changes per month: how many commits, changes in word count and LOC, new references, links, etc added

## Design Improvements

- Margin notes
- Drop caps
- Style code blocks
	- Custom syntax highlighting based on umt.world colourscheme
- Set of ornaments
	- End mark
	- Section mark
	- Manicule
	- Fleurons

## Photos
- A new style of page organized around single photos and photo galleries
- Design system based on Instagram
- Tagging and linking system for photos
- Pieces of visual culture, in addition to original photos

## Diaries

- Since the project is psychogeographical, it could use a mapping system
- Git history and complete evolution of every unit of text
- More metadata content in the margins

# Completed Tasks
- ~~Re-structure the diary into chronological chapters~~
	- How does the voice of the *Diaries* relate to the voice used throughout the website?
- ~~Add a link to page commit history in metadata~~
	* Doesn't add anything since putting collections in a submodule; there should still be some way to see the history of published files on github
- ~~"Last revised" parenthetical on diary entries with link to commit history~~
- ~~Sidenotes~~
	* Currently has some bugs relating to re-drawing sn to fn when resizing the viewport
- ~~Section headers should link to their anchor~~
- ~~Style image borders, add shadows~~
- ~~Graphic to separate section clusters~~
- ~~Change sidebar to top-style navbar~~
- ~~New logo~~
- ~~Footer, giving a better visual break from the page~~
- ~~Justified text with automatic hyphenation~~
	- No more than two annotations in a row
	- 3 characters before hyphen
	- No rivers
- ~~Responsive text size~~
