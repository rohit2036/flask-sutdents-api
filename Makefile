IMAGE_NAME = one2n-api
TAG = 1.0.0
REGISTRY = yourdockerhubusername/$(IMAGE_NAME)

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
	echo "$$DOCKER_PASS" | docker login -u "$$DOCKER_USER" --password-stdin

docker-build:
	docker build -t $(REGISTRY):$(TAG) .

docker-push: docker-login docker-build
	docker push $(REGISTRY):$(TAG)

all: install test lint docker-push