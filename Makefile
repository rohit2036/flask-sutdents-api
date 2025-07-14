IMAGE_NAME = one2n-api
TAG = 1.0.0
REGISTRY = rohit2036/$(IMAGE_NAME)

install:
	pip install --upgrade pip

run:
	flask run

migrate:
	flask db init || true
	flask db migrate -m "Initial migration"
	flask db upgrade

test:
	pytest tests

lint:
	flake8 app

docker-login:
	@echo "Logging in to Docker Hub..."
	@if [ -z "$(DOCKER_USERNAME)" ] || [ -z "$(DOCKER_PASSWORD)" ]; then \
		echo "DOCKER_USERNAME or DOCKER_PASSWORD is not set"; \
		exit 1; \
	fi
	echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin


docker-build:
	docker build -t $(REGISTRY):$(TAG) .

docker-push: docker-login docker-build
	docker push $(REGISTRY):$(TAG)

all: install test lint docker-push
