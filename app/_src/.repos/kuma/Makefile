# Installs npm packages and gems.
install:
	npm install -g netlify-cli
	yarn install
	bundle install

run:
	bundle exec jekyll serve --config jekyll.yml

build:
	bundle exec jekyll build --config jekyll.yml

serve:
	netlify dev

# Cleans up all temp files in the build.
# Run `make clean` locally whenever you're updating dependencies, or to help
# troubleshoot build issues.
clean:
	-rm -rf dist
	-rm -rf app/.jekyll-cache
