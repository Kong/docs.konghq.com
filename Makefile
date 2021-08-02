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

# Brings up a docker container and starts a doc site instance on
# http://localhost:3000.
develop:
	docker-compose up

# Cleans up all docker-compose containers and all temp files in the build.
# Run `make clean` locally whenever you're updating dependencies, or to help
# troubleshoot build issues.
# Used in build-test and check-links workflows.
clean:
	-docker-compose stop
	-docker-compose rm -f
	-rm -rf dist
	-rm -rf app/.jekyll-cache
	-rm yarn.lock
	-rm -rf node_modules
	-rm install

# Runs tests using the npm standard and echint linters.
test: install
	npm test

# Starts a docker container in the background.
background-docker-up:
	docker-compose up -d
	-while [ `curl -s -o /dev/null -w ''%{http_code}'' localhost:3000` != 200 ]; do echo "waiting"; docker-compose logs --tail=10 jekyll; sleep 45; done

# Starts a docker container in the background, then runs tests.
docker-test: background-docker-up
	docker-compose exec -T jekyll npm test

# Brings up a docker container, runs jekyll build, and checks all internal links.
check-links: background-docker-up
	docker-compose exec -T jekyll yarn blc http://localhost:3000 -efr --exclude hub --exclude kong-cloud --exclude community --exclude localhost:3000\/2\.4\.x --exclude localhost:3000\/2\.3\.x --exclude localhost:3000\/2\.2\.x --exclude localhost:3000\/2\.1\.x --exclude localhost:3000\/2\.0\.x --exclude localhost:3000\/1\.5\.x --exclude localhost:3000\/1\.4\.x --exclude localhost:3000\/1\.3\.x --exclude localhost:3000\/1\.2\.x --exclude localhost:3000\/1\.1\.x --exclude localhost:3000\/1\.0\.x --exclude localhost:3000\/0\.15\.x --exclude localhost:3000\/0\.14\.x --exclude localhost:3000\/0\.13\.x --exclude localhost:3000\/0\.12\.x --exclude localhost:3000\/0\.11\.x --exclude localhost:3000\/0\.10\.x --exclude localhost:3000\/0\.9\.x --exclude localhost:3000\/0\.8\.x --exclude localhost:3000\/0\.7\.x --exclude localhost:3000\/0\.6\.x --exclude localhost:3000\/0\.5\.x --exclude localhost:3000\/0\.4\.x --exclude localhost:3000\/0\.3\.x --exclude localhost:3000\/0\.2\.x

# Checks all internal links in a running http://localhost:3000 instance. To use
# this command, `make run` first, then `make check-links-local`.
check-links-local:
	yarn blc http://localhost:3000 -efr --exclude hub --exclude kong-cloud --exclude community --exclude localhost:3000\/2\.4\.x --exclude localhost:3000\/2\.3\.x --exclude localhost:3000\/2\.2\.x --exclude localhost:3000\/2\.1\.x --exclude localhost:3000\/2\.0\.x --exclude localhost:3000\/1\.5\.x --exclude localhost:3000\/1\.4\.x --exclude localhost:3000\/1\.3\.x --exclude localhost:3000\/1\.2\.x --exclude localhost:3000\/1\.1\.x --exclude localhost:3000\/1\.0\.x --exclude localhost:3000\/0\.15\.x --exclude localhost:3000\/0\.14\.x --exclude localhost:3000\/0\.13\.x --exclude localhost:3000\/0\.12\.x --exclude localhost:3000\/0\.11\.x --exclude localhost:3000\/0\.10\.x --exclude localhost:3000\/0\.9\.x --exclude localhost:3000\/0\.8\.x --exclude localhost:3000\/0\.7\.x --exclude localhost:3000\/0\.6\.x --exclude localhost:3000\/0\.5\.x --exclude localhost:3000\/0\.4\.x --exclude localhost:3000\/0\.3\.x --exclude localhost:3000\/0\.2\.x
