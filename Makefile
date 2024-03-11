.SHELL := /usr/bin/bash
.EXPORT_ALL_VARIABLES:

export TF_IN_AUTOMATION = 1
export README_INCLUDES ?= $(file://$(shell pwd)/?type=text/plain)


help:
	@grep -E '^[a-zA-Z_-_\/]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build website
	@docker buildx build --platform linux/amd64 . -t ifunky/site
	@docker image inspect ifunky/site

deploy: ## Deploy website
	@helm upgrade secsite-hugo ./helm/ifunky-secsite \
		--namespace=ifunky \
		--create-namespace \
		--wait \
		--install \
		--values helm/ifunky-secsite/values.yaml \
		--set image.repository=ifunky/site \
		--set image.tag=latest

delete: ## Deploy website
	@helm uninstall secsite-hugo

run: ## Run site in docker
	docker run -p 8080:80 secops
	echo "Goto http://http://localhost:8080/"

push: ## Piush to docker repo
	@docker tag secops ifunky/site
	@docker push ifunky/site:latest