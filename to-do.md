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
	- We currently have the issue of a page appearing in its own backlinks when it contains a link to itself
	- Context should be the surrounding paragraph to a max of 250 words equally distributed on either side of the link, cut off at the nearest sentence.
	- Context should preserve formatting, including links
		- What about footnotes?
	- Format should be as a list, with the Title of the page as a hyperlink, and an optional (full context) parenthetical linking to the sub-section
	- The content of the backlink should appear in a blockquote
	- Skip adding backlinks to binaries or links that are not contained on the root domain
	- The plugin is also generating the section in the HTML even if there are no items to populate it
	- Requires an automated build script with development and deployment options
- Metadata sections
	- Bibliography, Footnotes, Backlinks, Similar Links sections in the TOC
	- Only if the items exist
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

- Section headers
	- Consistent use of the paragraph symbol for all levels
	- Shows on hover with some opacity
	- Stays when section is clicked with zero opacity
- Unique list style types
- Auto / light / dark mode
- TOC
	- Numbered levels that only show in larger viewports
	- Background of entry is dark when hovered
	- Little bar at the end of the highlighted line

# Medium Priority

## Visual Enhancements

- Typographic style for all references in the Bibliography section
- Lightbox option for images
- Slideshow option for images
- More multi-media in *Diaries* for more of a scrapbook design
- Create a better visual system to organize categories
- Graphic divider for the Footnotes section

## Navigation Improvements

- Link annotations
	- Annotations for different filetypes
	- Annotations for newly-updated internal links
- CSS icons
	- Favicons for external website
- Return to Top button
- "Similar Links" section
	- Similar Links based on tagging
- Title of *Diary* entry should link to its anchor
- Bibliographic items should automatically have a link to the archived item
	- We will eventually need to just come up with our own CSL.

# Long-term

## Content Enrichment

- "Blogroll" section on the bottom of each page that selects a quote, pdf, link, image (?) for each day
- Group items in the Changelog under a single list item per category
- Changelog summary for ongoing projects: "Diary: +400 words, -200 words, 23% different."
- Changelog summary of changes per month: how many commits, changes in word count and LOC, new references, links, etc added
- Modify the CSL so that each reference points to an item included

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
- Typographic system
	- The current system is too Art Deco. We want to move towards an eclectic style with industrial influences
	- We need a serif typeface for headers that is
		- characterful
		- contains a full range of styles and weights

## Photos
- A new style of page organized around single photos and photo galleries
- Design system based on Instagram
- Tagging and linking system for photos
- Pieces of visual culture, in addition to original photos

## Diaries

- Since the project is psychogeographical, it could use a mapping system
- Git history and complete evolution of every unit of text
- This is precisely the page to disrupt the system with marginalia and eclectic fonts

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
