install-prerequisites:
	npm install -g gulp netlify-cli

# Installs npm packages and gems.
install:
	npm ci
	bundle install

# Using local dependencies, starts a doc site instance on http://localhost:3000.
run:
	./node_modules/.bin/gulp

build:
	./node_modules/.bin/gulp build

# Cleans up all temp files in the build.
# Run `make clean` locally whenever you're updating dependencies, or to help
# troubleshoot build issues.
clean:
	-rm -rf dist
	-rm -rf app/.jekyll-cache

# Runs tests
test:
	npm test

smoke:
	@netlify dev & echo $$! > netlify.PID
	@sleep 3
	@npm run test:smoke || true
	@kill -TERM $$(cat netlify.PID)
	@rm netlify.PID