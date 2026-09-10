# Contributing to CyberLavandaTea

Thanks for taking the time to help.

## Ground rules

- **English only** for code, comments, commit messages, docs and issues.
- The theme is **dark-only** on purpose — please don't add a light mode.
- The palette is six roles plus two derived surfaces. New colours in the site
  *chrome* are out of scope; syntax highlighting may use the two documented
  tints and the single error red, and nothing else.
- Keep the layout working **without** Tailwind's content detection: put real
  styling in `assets/css/main.css` (`@layer base` / `@layer components` / plain
  rules), not only in template class attributes.

## Local development

```bash
npm install
npm --prefix exampleSite install
hugo server -s exampleSite --themesDir ../..
```

Or, module-style:

```bash
cd exampleSite
hugo mod get -u
hugo server
```

## Before opening a PR

- `hugo --source exampleSite --themesDir ../.. --environment production` builds
  with no errors and no new deprecation warnings.
- Add an entry to `CHANGELOG.md` under `## [Unreleased]`.
- If you touched params or front matter, update `README.md`.

## Releasing (maintainers)

Hugo Modules resolve theme versions from Git tags, so cutting a release is
just: **merge a PR that adds an entry under `## [Unreleased]` in
`CHANGELOG.md`.**

The [Release workflow](.github/workflows/release.yml) then runs on `main` and:

- moves that entry into a new `## [X.Y.Z] - YYYY-MM-DD` section (leaving a
  fresh empty `## [Unreleased]` above it) and bumps `package.json`'s
  `version` to match,
- infers the bump from the Keep a Changelog headings in the entry —
  `### Removed` → major, `### Added` → minor, anything else → patch — and
  commits it,
- tags the commit `vX.Y.Z` and publishes a GitHub Release with that entry as
  notes.

To force a specific bump instead of the inferred one, run the workflow
manually from the Actions tab (`workflow_dispatch`) with the `bump` input.
An `## [Unreleased]` section with no content is a no-op — nothing is
released until there's something to say.
