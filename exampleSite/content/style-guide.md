+++
title = "Style Guide"
description = "Every element the theme styles, on one page: headings, lists, links, images, quotes, tables, code and the color/type reference."
date = 2026-09-13T09:00:00+02:00
tags = ["design", "reference"]
toc = true
+++

This page exists to be looked at, not read — every element CyberLavandaTea
styles, rendered once, in order, so a change to `_tokens.scss` or
`_components.scss` shows up here first. It also proves the small stuff
still works: footnotes,[^1] for instance.

# This is a heading level one

Rendered with the display face, an anchor `id` from its slug, and a
pilcrow (`¶`) that fades in on hover — the same render hook handles every
level below.

## This is a heading level two

Also the level this page uses for its own section headers, which is why
it shows up nested under "Heading level one" in the table of contents
above.

### This is a heading level three

#### This is a heading level four

## Body text

This theme renders Goldmark's Markdown plus a handful of render hooks of
its own. Inline styles work as expected: *emphasis*, **strong emphasis**,
`inline code`, and a link to [Hugo](https://gohugo.io/) — external, so it
picks up the outbound arrow.

## Lists

An unordered list, nested one level, in the tree-triangle marker:

- Static site generators
  - Hugo (Go — this site)
  - Eleventy (Node)
  - Zola (Rust)
- Build tooling
  - Tailwind CSS v4
  - Dart Sass

And an ordered list, in zero-padded mono indices, because sequence
matters here:

1. Write Markdown in `content/`.
2. Hugo compiles templates and Markdown into static HTML.
3. Tailwind processes `assets/css/main.css` and purges unused utilities.
4. `public/` ships to a static host.

## Links

An unvisited link is Link-blue, like the one to [Hugo](https://gohugo.io/)
above. This link back to [the Lists section](#lists) turns Visited-sage
once you've clicked it. On `:hover` or `:focus` any link switches to
Primary green, with a focus ring for keyboard navigation.

## Images

A lone image becomes a `<figure>` with a caption, centered:

![Mountain lake](https://picsum.photos/id/1015/1000/560 "A placeholder photo, because every style guide needs one")

## Quote

> The full layout is written in plain CSS, so the theme renders correctly
> even without Tailwind's content detection.

## Tables

| Format | Path | Consumed by |
|---|---|---|
| RSS | `/index.xml` | most feed readers |
| Atom | `/atom.xml` | feed readers, PubSubHubbub |
| JSON Feed | `/index.json` | JSON Feed readers |
| SearchIndex | `/search.json` | this site's own client-side search |

## Code

```go
// buildIndex writes the search index used by /search.
const maxResults = 40

func buildIndex(posts []Post) (string, error) {
	count := 0
	for _, p := range posts {
		if p.Draft {
			continue
		}
		count++
	}
	return fmt.Sprintf("indexed %d posts", count), nil
}
```

## Buttons

<p><a class="btn" href="/search/">Try the search →</a></p>

## Color & type reference

<style>.style-guide-swatch{display:inline-block;width:0.85em;height:0.85em;border-radius:3px;vertical-align:-0.05em;margin-right:.5em;border:1px solid var(--color-border);}</style>

The same six roles, read directly from `assets/scss/_tokens.scss`:

| Role | | Hex |
|---|---|---|
| Primary | <span class="style-guide-swatch" style="background:#5FD88F"></span> | `#5FD88F` |
| Content | <span class="style-guide-swatch" style="background:#E6E6EC"></span> | `#E6E6EC` |
| Background | <span class="style-guide-swatch" style="background:#14151A"></span> | `#14151A` |
| Link | <span class="style-guide-swatch" style="background:#4D9FFF"></span> | `#4D9FFF` |
| Visited | <span class="style-guide-swatch" style="background:#7EA88E"></span> | `#7EA88E` |
| Inactive | <span class="style-guide-swatch" style="background:#8B8F9A"></span> | `#8B8F9A` |

And the two typefaces that carry it:

| Role | Typeface |
|---|---|
| Display | Audiowide |
| Body | Rajdhani |
| Mono | JetBrains Mono (stack) |
| Signature | Sig Font, cursive fallback |

[^1]: Goldmark's footnote extension, rendered automatically below — and yes, it's an `<ol>`, so it gets the same zero-padded markers as every other numbered list on this page.
