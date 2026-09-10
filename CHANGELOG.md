# Changelog

All notable changes to this theme are documented here.
The format is loosely based on [Keep a Changelog](https://keepachangelog.com/).

## [1.1.0] - 2026-09-10

### Added

- Switch changelog generation to git-cliff

## [0.1.1] - 2026-09-10

### Added

- Add GitHub Pages deployment workflow and update demo site URL
- Add multiple example posts with various content types
- Refactor SCSS structure and integrate TailwindCSS
- Introduce automated release cutting script
- Implement green and blue color palette redesign

### Changed

- Update all remaining palette references and examples

### Documentation

- Introduce detailed style guide for theme visual language

### Fixed

- Update data source references in 88x31 badges and humanstxt
- Update Mastodon username for comments section
- Correct formatting and indentation in hugo.toml configuration
- Resolve mobile horizontal scroll and menu overlap with pride corner
- Collapse series list by default

### Miscellaneous Tasks

- Remove outdated example posts for clarity and maintenance
- Add GitHub Actions workflow for automated releases
- Add unreleased entry for color palette redesign

### Other

- Configurable pronouns / location / status in the footer
- Claude PR Assistant workflow
- Claude Code Review workflow

## [0.1.0] - 2026-09-08

### Other

- Add CyberLavandaTea Hugo theme (Tailwind v4, dark-only)
- Webrings in the footer
- Font Awesome type icons + opt-in LGBT+ corner
- Rewrite content/style-guide.md for the CyberLavandaTea theme
- All-English, ready as a standalone module
- Config-driven favicons + working webmentions
- Full Mastodon comments thread
- Prettier syndication labels
- Vendor the runtime libraries into the theme
- Fix search crash on special-character queries
- Configurable "Reference this post" box
- Make the webmention "Responses" block work
- Fix webmention data-page-url on `hugo server`
