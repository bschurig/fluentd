REPO = bschurig
IMAGE = fluentd-elasticsearch
TAG = $(shell git log --pretty=format:'%h' -n 1)

build:
	docker build -t $(REPO)/$(IMAGE):$(TAG) .

push:
	docker push $(REPO)/$(IMAGE):$(TAG)