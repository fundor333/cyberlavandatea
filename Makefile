# CyberLavandaTea — theme development
# The site is built from exampleSite/, which needs @tailwindcss/cli in its own
# node_modules so Hugo's css.TailwindCSS can find the `tailwindcss` binary.

SITE_DIR := exampleSite
HUGO     ?= hugo
NPM      ?= npm

.DEFAULT_GOAL := dev

.PHONY: install dev serve build clean

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

clean:
	rm -rf $(SITE_DIR)/public $(SITE_DIR)/resources $(SITE_DIR)/node_modules
	rm -f $(SITE_DIR)/.hugo_build.lock .hugo_build.lock
