install-prerequisites:
	npm install -g yarn
	npm install -g gulp

install:
	npm install
	bundle install
	yarn --ignore-engines
	yarn upgrade

run: install
	gulp

develop:
	docker-compose up

test: install
	npm test

docker-test:
	COMMAND="make test" docker-compose up

check-links:
	docker-compose up -d
	while [ `curl -s -o /dev/null -w ''%{http_code}'' localhost:3000` != 200 ]; do echo "waiting"; docker-compose logs jekyll; sleep 20; done
	docker-compose exec jekyll yarn blc http://localhost:3000 -efr --exclude careers --exclude hub
