# CyberLavandaTea — Style Guide

This document describes the visual language of the theme: color system,
typography, spacing, components and motion. It is the canonical reference for
anyone extending the theme or overriding its tokens from a site config. The
single source of truth for the values below is
[`assets/scss/_tokens.scss`](../assets/scss/_tokens.scss); this guide explains
*why* those values are what they are.

## 1. Principles

- **Dark-only, by design.** There is no light-mode toggle and none is
  planned. `assets/js/theme.js` locks `class="dark"` before first paint, and
  `color-scheme: dark` is set on `:root` so native form controls, scrollbars
  and the browser UI stay dark too.
- **Minimal hue count.** The chrome uses exactly two hues — one accent
  (green) and one signal color (blue) — plus neutrals. Every other visible
  color (surfaces, borders, hover states) is *derived* from those two plus
  the neutrals, not a new hue introduced ad hoc. This is what keeps the
  theme from accumulating an arbitrary palette over time.
- **Plain CSS first.** The full layout is written in plain CSS
  (`assets/scss/_components.scss`); Tailwind utilities are a convenience for
  site authors writing their own content/shortcodes, not a rendering
  dependency. A site with no Tailwind build step still renders correctly.
- **Tokens, not literals.** Every rule in the theme reads color from a
  `--color-*` custom property (or a `color-mix()` built from one). No
  component hardcodes a hex value — that is what makes the palette
  swappable from a single file.

## 2. Color system

### 2.1 The six roles

| Role | Token | Hex | Used for |
|---|---|---|---|
| Primary | `--color-primary` | `#5FD88F` | accent/brand, `:hover`/`:focus`, active nav item, focus ring, `blockquote` left border, keywords in code |
| Content | `--color-content` | `#E6E6EC` | body text, headings, `strong`, code text |
| Background | `--color-background` | `#14151A` | `body`, navbar, footer |
| Link | `--color-link` | `#4D9FFF` | unvisited links, strings in code, added-diff lines |
| Visited | `--color-visited` | `#7EA88E` | `a:visited` |
| Inactive | `--color-inactive` | `#8B8F9A` | meta text, dates, placeholders, code comments, disabled state |

Primary and Link are deliberately far apart on the hue wheel (green vs.
blue) so the two accent meanings — "this is the brand/interactive color"
vs. "this is a link/string" — stay visually distinct even to a reader
skimming quickly or with partial color-vision deficiency. Nothing else in
the chrome introduces a third hue.

### 2.2 Derived surfaces

Surfaces and borders are not separate colors — they are the neutrals of the
system, computed as Content mixed into Background at a fixed opacity. This
guarantees that as `--color-content` or `--color-background` are retuned,
every surface and border stays in proportion automatically.

| Token | Hex | Formula | Used for |
|---|---|---|---|
| `--color-surface` | `#25262B` | Content @ 8% over Background | `code`, `pre`, `.toc`, `blockquote`, `tr:nth-child(even)` |
| `--color-surface-2` | `#2D2E33` | Content @ 12% over Background | surface hover state |
| `--color-border` | `#313237` | Content @ 14% over Background | `hr`, dividers, component borders |

### 2.3 Syntax (Chroma) tints

Code highlighting stays inside the same two-hue system, plus one dedicated
error color used only inside `<pre>`:

| Token | Hex | Derived from | Used for |
|---|---|---|---|
| `--color-code-fn` | `#A8C9FF` | light tint of Link | function/class names |
| `--color-code-num` | `#8FE0AF` | light tint of Primary | numbers, constants |
| `--color-code-err` | `#FF6F6F` | standalone | errors, removed-diff lines |

### 2.4 Why green leads, and why not violet

The theme shipped its first version with a violet/lavender primary. It was
replaced because, at the lightness needed for AA/AAA contrast on a near-black
background, the violet read as pastel and washed out rather than deliberate.
Green and blue — the two hues that replaced it — were tried in both
directions (green-as-accent/blue-as-link, and the reverse) with everything
else held constant. Green measures the higher contrast of the two against
`--color-background` (~10:1, AAA) and so carries the *Primary* role — the
one used for interactive state, focus rings and buttons, where the extra
contrast matters most. Blue, comfortably AA at ~6.7:1, carries *Link*. Both
stay far enough apart on the hue wheel that "this is the brand/interactive
color" and "this is a link/string" remain distinct even to a reader
skimming quickly or with partial color-vision deficiency — the problem the
old violet/lavender pairing had, since primary and visited sat too close in
hue to tell apart at a glance.

### 2.5 Contrast

Every text pairing used by the theme clears WCAG AA (4.5:1) for normal
text, and most clear AAA (7:1):

| Pairing | Ratio | Level |
|---|---|---|
| Content on Background | ~14.7:1 | AAA |
| Content on Surface | ~12.2:1 | AAA |
| Primary on Background | ~10.2:1 | AAA |
| Link on Background | ~6.7:1 | AA (large-text AAA) |
| Inactive on Background | ~5.6:1 | AA |

`::selection` and `:focus-visible` both use `color-mix()` against Primary
rather than a fixed alpha color, so they track any future retune of the
token automatically.

## 3. Typography

| Role | Token | Stack | Used for |
|---|---|---|---|
| Display | `--font-display` | `"Audiowide", ui-sans-serif, system-ui, sans-serif` | headings, nav, buttons, post titles, brand |
| Body | `--font-sans` | `"Rajdhani", ui-sans-serif, system-ui, sans-serif` | body copy |
| Signature | `--font-signature` | `"Sig Font", "Ocean Trace", "Segoe Script", ui-rounded, cursive` | the "written by a human" line |
| Mono | `--font-mono` | `ui-monospace, "SF Mono", "JetBrains Mono", Menlo, monospace` | inline code, code blocks |

Audiowide is a squared, geometric display face used sparingly — headings,
nav labels, buttons — to keep its character from overwhelming a page of
running text. Rajdhani, the body face, is a narrower grotesque that stays
comfortable at the theme's base size (1.0625rem / 17px, 1.65 line-height)
across long-form posts.

Type scale (base 1.0625rem):

| Element | Size | Notes |
|---|---|---|
| `h1` | 2rem | `letter-spacing: -0.015em` |
| `h2` | 1.5rem | |
| `h3` | 1.25rem | |
| body | 1.0625rem | line-height 1.65 |
| inline code | 0.85em | |
| `pre` | 0.9rem | line-height 1.7 |

Both display and body fonts are loaded from Google Fonts by default
(`params.fonts`); a site can self-host instead. The signature font has no
bundled face — set `params.fonts.signature` to a font-file URL, or ship
your own `@font-face` via `custom-head`.

## 4. Layout & spacing

- **Content width**: `.wrapper` caps at `46rem` (~736px), centered — tuned
  for prose line length, not a generic grid.
- **Radius**: one shared radius token, `--radius-panel: 0.75rem`, used on
  every panel-like surface (`pre`, `.toc`, back-to-top button, `.toot`).
  Small inline elements (`code`, tags) use a tighter 4px so they read as
  "part of the text," not as their own panel.
- **Borders**: 1px, always `--color-border`, never a shadow — the theme has
  no drop shadows; depth comes from surface-opacity steps, not elevation.
- **Rhythm**: prose (`.e-content`) uses a flat `margin-top: 1.1rem` on every
  direct child rather than per-element margins, so vertical rhythm stays
  consistent regardless of which elements a post happens to use.

## 5. Components

- **Navbar** (`.navbar`): display font at 13px, uppercase-adjacent letter
  spacing (`0.03em`). Active/hover nav items switch to Primary. Collapses to
  a centered, checkbox-driven hamburger menu below 640px — no JS required
  for the toggle.
- **Post list / post item**: title in the display font at normal weight
  (the face itself carries enough presence at display sizes); meta
  (date, icon) in Inactive.
- **Buttons** (`.btn`): filled Primary background, Background-colored text
  (Primary is light enough at its current lightness for this to stay AA);
  hover lightens Primary toward white via `color-mix()`.
- **Code**: inline code and `pre` both sit on Surface with a Border edge;
  `pre` additionally gets `--radius-panel`. Chroma classes map to the
  syntax tints in §2.3.
- **Blockquote**: Surface background, a 4px Primary left border, Inactive
  text — reads as "aside," not body copy.
- **TOC, `.toot`, comments**: same Surface/Border/`--radius-panel` panel
  treatment as code blocks, so all "boxed" content in a post looks like one
  family of components.
- **Tags, social icons, footer links**: Inactive by default, Primary on
  hover — the same interactive-state pattern used everywhere else, so
  hover behavior is predictable across the whole theme rather than
  component-specific.

## 6. Motion

- One easing token, `--ease-standard: cubic-bezier(0.4, 0, 0.2, 1)`, used
  everywhere something transitions (links, back-to-top, heading anchors).
- Durations are short and utilitarian — 120–150ms — because these are state
  changes (hover, focus, visibility), not featured animation.
- `assets/scss/_reduced-motion.scss` disables/shortens these under
  `prefers-reduced-motion: reduce`.

## 7. Customizing the palette

To retheme a site without forking the theme, override the `@theme` custom
properties from a site-level stylesheet loaded after the theme's (see
`custom-head` in the README), or fork `assets/scss/_tokens.scss` directly if
vendoring the theme as a Git submodule. Keep the same discipline this guide
describes: pick at most one accent hue and one signal hue, derive every
surface/border from Content-over-Background opacity rather than adding new
literals, and re-check the contrast pairings in §2.5 after any change.
