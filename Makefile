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
	docker-compose exec -T jekyll npm test

check-links: background-docker-up
	docker-compose exec -T jekyll yarn blc http://localhost:3000 -efr --exclude careers --exclude hub --exclude kong-cloud --exclude community --exclude 2.3.x --exclude 2.2.x --exclude 2.1.x --exclude 2.0.x --exclude 1.5.x --exclude 1.4.x --exclude 1.3.x --exclude 1.2.x --exclude 1.1.x --exclude 1.0.x --exclude 0.14.x --exclude 0.13.x --exclude 0.12.x --exclude 0.11.x --exclude 0.10.x --exclude 0.9.x --exclude0.8.x --exclude0.7.x --exclude 0.6.x --exclude 0.5.x --exclude 0.4.x --exclude 0.3.x --exclude 0.2.x
