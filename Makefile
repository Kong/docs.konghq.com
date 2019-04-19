develop: clean
	docker-compose up --build

clean:
	sudo rm -rf dist
	sudo rm -rf node_modules
