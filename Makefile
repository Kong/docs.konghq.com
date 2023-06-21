RUBY_VERSION := "$(shell ruby -v)"
RUBY_VERSION_REQUIRED := "$(shell cat .ruby-version)"
RUBY_MATCH := $(shell [[ "$(shell ruby -v)" =~ "ruby $(shell cat .ruby-version)" ]] && echo matched)

.PHONY: ruby-version-check
ruby-version-check:
ifndef RUBY_MATCH
	$(error ruby $(RUBY_VERSION_REQUIRED) is required. Found $(RUBY_VERSION). $(newline)Run `rbenv install $(RUBY_VERSION_REQUIRED)`)$(newline)
endif

install-prerequisites:
	npm install -g gulp netlify-cli

# Installs npm packages and gems.
install: ruby-version-check
	npm ci
	bundle install
	git submodule update --init

# Using local dependencies, starts a doc site instance on http://localhost:3000.
run: ruby-version-check
	./node_modules/.bin/gulp

build: ruby-version-check
	./node_modules/.bin/gulp build

# Cleans up all temp files in the build.
# Run `make clean` locally whenever you're updating dependencies, or to help
# troubleshoot build issues.
clean:
	-rm -rf dist
	-rm -rf app/.jekyll-cache
	-rm -rf app/.jekyll-metadata

# Runs tests
test:
	npm test

smoke:
	@netlify dev & echo $$! > netlify.PID
	@sleep 3
	@npm run test:smoke || true
	@kill -TERM $$(cat netlify.PID)
	@rm netlify.PID
