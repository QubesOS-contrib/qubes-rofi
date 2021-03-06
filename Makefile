DIST ?= fc33
VERSION := $(shell cat version)
REL := 1

FEDORA_SOURCES := https://src.fedoraproject.org/rpms/rofi/raw/f$(subst fc,,$(DIST))/f/sources
SRC_FILE := rofi-$(VERSION).tar.gz

BUILDER_DIR ?= ../..
SRC_DIR ?= qubes-src

DISTFILES_MIRROR ?= https://github.com/DaveDavenport/rofi/releases/download/$(VERSION)/
UNTRUSTED_SUFF := .UNTRUSTED
FETCH_CMD := wget --no-use-server-timestamps -q -O

SHELL := /bin/bash

%: %.sha512
	@$(FETCH_CMD) $@$(UNTRUSTED_SUFF) $(DISTFILES_MIRROR)$@
	@sha512sum --status -c <(printf "$$(cat $<)  -\n") <$@$(UNTRUSTED_SUFF) || \
			{ echo "Wrong SHA512 checksum on $@$(UNTRUSTED_SUFF)!"; exit 1; }
	@mv $@$(UNTRUSTED_SUFF) $@

.PHONY: get-sources
get-sources: $(SRC_FILE)

.PHONY: verify-sources
verify-sources:
	@true

# This target is generating content locally from upstream project
# 'sources' file. Sanitization is done but it is encouraged to perform
# update of component in non-sensitive environnements to prevent
# any possible local destructions due to shell rendering
.PHONY: update-sources
update-sources:
		@$(BUILDER_DIR)/$(SRC_DIR)/builder-rpm/scripts/generate-hashes-from-sources $(FEDORA_SOURCES)
