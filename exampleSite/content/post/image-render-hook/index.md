+++
title = "Images: what the render hook does"
date = 2026-11-14T10:00:00+01:00
description = "Every case handled by the theme's image render hook: page resources, global assets, remote URLs, SVG, GIF, captions and inline images."
tags = ["hugo", "images", "markdown"]
categories = ["dev"]
toc = true
+++

The theme ships an image render hook (`layouts/_markup/render-image.html`)
that turns plain Markdown images into responsive markup. Here is what it does
with each kind of source, so you can check how it looks.

## How the hook picks an image

1. It looks for the file next to the post, in the **page bundle**.
2. Failing that, it looks in the site's **`assets/`** folder.
3. Anything else (a remote URL, a file in `static/`) is output as a plain
   `<img>`, unchanged.

JPG, PNG and WebP files are **processed**: they are resized to at most 1600px
wide and wrapped in a `<picture>` with AVIF and WebP sources, with `width` and
`height` set so the page doesn't jump while it loads. SVG and GIF are left as
they are.

## Block image with a caption

An image on its own line becomes a `<figure>`, and its title becomes the
`<figcaption>`.

```markdown
![A blue-to-green gradient](landscape.jpg "Page resource, 2400px wide: resized to 1600px")
```

![A blue-to-green gradient](landscape.jpg "Page resource, 2400px wide: resized to 1600px")

## Block image without a caption

No title means no `<figcaption>`. The image is smaller than 1600px, so it is
converted but not resized.

```markdown
![A dark gradient labelled 800 × 500 PNG](small.png)
```

![A dark gradient labelled 800 × 500 PNG](small.png)

## WebP source

A WebP file gets only an AVIF `<source>`: a WebP source would duplicate the
fallback `<img>`.

```markdown
![A green radial gradient](photo.webp "WebP in, AVIF added")
```

![A green radial gradient](photo.webp "WebP in, AVIF added")

## Global asset

The file lives in `assets/images/`, not in the post folder. It is processed
like a page resource.

```markdown
![A green banner](images/global-banner.jpg "From assets/images/")
```

![A green banner](images/global-banner.jpg "From assets/images/")

## Inline image

An image inside a sentence stays inline. Its title becomes a `title`
attribute (a tooltip) instead of a caption: here is one
![small gradient](small.png "Inline: hover for the title") in the middle of a
line.

```markdown
here is one ![small gradient](small.png "Inline: hover for the title") in the middle
```

## SVG

Vector images can't be resized or converted, so they are output as they are.

```markdown
![Diagram: Markdown becomes picture](diagram.svg "SVG: passed through unchanged")
```

![Diagram: Markdown becomes picture](diagram.svg "SVG: passed through unchanged")

## Animated GIF

GIFs are left alone too, so the animation survives.

```markdown
![A blinking dot](blink.gif "GIF: not processed, the animation is kept")
```

![A blinking dot](blink.gif "GIF: not processed, the animation is kept")

## Remote image

A full URL is never downloaded or processed. It becomes a plain `<img>` with
lazy loading.

```markdown
![A mountain lake](https://picsum.photos/id/1015/1000/560 "Remote: plain img")
```

![A mountain lake](https://picsum.photos/id/1015/1000/560 "Remote: plain img")

## Alt text

The alt text is the text between the brackets, with any Markdown stripped (and
straight quotes turned into curly ones by Goldmark's typographer). Leave it empty only for purely decorative images.

```markdown
![A gradient with **bold** and "quotes"](small.png)
```

![A gradient with **bold** and "quotes"](small.png)
