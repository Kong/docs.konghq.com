install-prerequisites:
	npm install -g gulp

install:
	-mkdir -p node_modules
	chmod 777 node_modules
	bundle install
	yarn --ignore-engines
	touch install

run: install
	-chmod -R 777 dist
	gulp

develop:
	docker-compose up

clean:
	-docker-compose stop
	-docker-compose rm -f
	-rm -rf dist
	-rm yarn.lock
	-rm -rf node_modules
	-rm install

test: install
	npm test

background-docker-up:
	docker-compose up -d
	-while [ `curl -s -o /dev/null -w ''%{http_code}'' localhost:3000` != 200 ]; do echo "waiting"; docker-compose logs --tail=10 jekyll; sleep 45; done

docker-test: background-docker-up
	docker-compose exec -T jekyll npm test

check-links: background-docker-up
	docker-compose exec -T jekyll yarn blc http://localhost:3000 -efr --exclude careers --exclude hub --exclude kong-cloud --exclude community --exclude localhost:3000\/2\.4\.x --exclude localhost:3000\/2\.3\.x --exclude localhost:3000\/2\.2\.x --exclude localhost:3000\/2\.1\.x --exclude localhost:3000\/2\.0\.x --exclude localhost:3000\/1\.5\.x --exclude localhost:3000\/1\.4\.x --exclude localhost:3000\/1\.3\.x --exclude localhost:3000\/1\.2\.x --exclude localhost:3000\/1\.1\.x --exclude localhost:3000\/1\.0\.x --exclude localhost:3000\/0\.15\.x --exclude localhost:3000\/0\.14\.x --exclude localhost:3000\/0\.13\.x --exclude localhost:3000\/0\.12\.x --exclude localhost:3000\/0\.11\.x --exclude localhost:3000\/0\.10\.x --exclude localhost:3000\/0\.9\.x --exclude localhost:3000\/0\.8\.x --exclude localhost:3000\/0\.7\.x --exclude localhost:3000\/0\.6\.x --exclude localhost:3000\/0\.5\.x --exclude localhost:3000\/0\.4\.x --exclude localhost:3000\/0\.3\.x --exclude localhost:3000\/0\.2\.x
