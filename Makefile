# CyberLavandaTea — theme development
# The site is built from exampleSite/, which needs @tailwindcss/cli in its own
# node_modules so Hugo's css.TailwindCSS can find the `tailwindcss` binary.

SITE_DIR := exampleSite
HUGO     ?= hugo
NPM      ?= npm
CLIFF    ?= git-cliff

.DEFAULT_GOAL := dev

.PHONY: install dev serve build regenerate clean version bump changelog release tag

# Install the exampleSite JS deps (tailwindcss CLI). Re-runs only when
# package.json changes relative to the installed node_modules.
$(SITE_DIR)/node_modules: $(SITE_DIR)/package.json
	cd $(SITE_DIR) && $(NPM) install
	@touch $@

install: $(SITE_DIR)/node_modules

# Live-reloading dev server with drafts/future/expired content enabled.
dev serve: install
	cd $(SITE_DIR) && $(HUGO) server --buildDrafts --buildFuture --buildExpired --disableFastRender

# One-off dev build (drafts included) into exampleSite/public.
build: install
	cd $(SITE_DIR) && $(HUGO) --gc --buildDrafts

# Force a from-scratch regeneration: wipe Hugo's resource cache/public
# output and exampleSite's node_modules, then reinstall and rebuild. Use
# this when a stale cache (e.g. Tailwind output) hides the effect of a change.
regenerate: clean build

clean:
	rm -rf $(SITE_DIR)/public $(SITE_DIR)/resources $(SITE_DIR)/node_modules
	rm -f $(SITE_DIR)/.hugo_build.lock .hugo_build.lock

# --- Versioning --------------------------------------------------------
# The version lives in package.json; releases are tagged `vX.Y.Z` and the
# changelog is generated from Conventional Commits via git-cliff (cliff.toml).

# Print the current version from package.json.
version:
	@node -p "require('./package.json').version"

# Regenerate CHANGELOG.md from the full commit history.
# VERSION=X.Y.Z labels the commits since the last tag as that release;
# omit it to leave them under "## [Unreleased]".
changelog:
	$(CLIFF) $(if $(VERSION),--tag v$(VERSION)) -o CHANGELOG.md
	@printf '%s\n' "$$(cat CHANGELOG.md)" > CHANGELOG.md

# Bump the version in package.json. Usage: make bump VERSION=1.2.0
bump:
	@test -n "$(VERSION)" || (echo "usage: make bump VERSION=X.Y.Z" >&2; exit 1)
	node -e "const fs=require('fs');const p=require('./package.json');p.version='$(VERSION)';fs.writeFileSync('package.json', JSON.stringify(p, null, 2) + '\n');"

# Cut a release: bump the version, regenerate the changelog for it, and
# commit the result. Does not tag or push — review the commit, then run
# `make tag VERSION=X.Y.Z` (and push both the branch and the tag) yourself.
# Usage: make release VERSION=1.2.0
release: bump changelog
	git add package.json CHANGELOG.md
	git commit -m "chore(release): v$(VERSION)"

# Create an annotated tag for the current HEAD. Usage: make tag VERSION=1.2.0
tag:
	@test -n "$(VERSION)" || (echo "usage: make tag VERSION=X.Y.Z" >&2; exit 1)
	git tag -a "v$(VERSION)" -m "v$(VERSION)"
