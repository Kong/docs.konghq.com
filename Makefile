# Installs gulp.
install-prerequisites:
	npm install -g gulp

# Installs npm packages and gems.
install:
	-mkdir -p node_modules
	chmod 777 node_modules
	bundle install
	yarn --ignore-engines
	touch install

# Using local dependencies, starts a doc site instance on http://localhost:3000.
run: install
	-chmod -R 777 dist
	gulp

build: install
	-chmod -R 777 dist
	./node_modules/.bin/gulp build

# Brings up a docker container and starts a doc site instance on
# http://localhost:3000.
develop:
	docker-compose up

# Cleans up all temp files in the build.
# Run `make clean` locally whenever you're updating dependencies, or to help
# troubleshoot build issues.
clean:
	-rm -rf dist
	-rm -rf app/.jekyll-cache
	-rm yarn.lock
	-rm -rf node_modules
	-rm install

# docker-clean is here for legacy purposes, in case we ever decide to fix our
# docker-compose. These commands were previously part of `clean`.
docker-clean:
	-docker-compose stop
	-docker-compose rm -f

# Runs tests using the npm standard and echint linters.
test: install
	npm test

rspec: install
	bundle exec rspec

# Starts a docker container in the background.
background-docker-up:
	docker-compose up -d
	-while [ `curl -s -o /dev/null -w ''%{http_code}'' localhost:3000` != 200 ]; do echo "waiting"; docker-compose logs --tail=10 jekyll; sleep 45; done

# Starts a docker container in the background, then runs tests.
docker-test: background-docker-up
	docker-compose exec -T jekyll npm test
