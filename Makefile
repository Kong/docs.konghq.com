install-prerequisites:
	npm install -g yarn
	npm install -g gulp

install:
	-mkdir node_modules
	chmod 777 node_modules
	npm install
	bundle install
	yarn --ignore-engines
	yarn upgrade
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
	docker-compose exec jekyll npm test

check-links: background-docker-up
	docker-compose exec jekyll yarn blc http://localhost:3000 -efr --exclude careers --exclude hub --exclude request-demo --exclude kong-cloud