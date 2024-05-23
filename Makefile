.SHELL := /usr/bin/bash
.EXPORT_ALL_VARIABLES:

export TF_IN_AUTOMATION = 1
export README_INCLUDES ?= $(file://$(shell pwd)/?type=text/plain)

WIZ_POLICES="Dan - Demo Vulnerabilities Policy,Dan - Sensitive Data Default"

help:
	@grep -E '^[a-zA-Z_-_\/]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build website
	@docker buildx build --platform linux/amd64 . -t ifunky/site:latest
	#@docker image inspect ifunky/site:latest

deploy: ## Deploy website
	@helm upgrade secsite-hugo ./helm/ifunky-secsite \
		--namespace=ifunky \
		--create-namespace \
		--wait \
		--install \
		--values helm/ifunky-secsite/values.yaml \
		--set image.repository=ifunky/site \
		--set image.tag=latest
scan: ## Scan image
	wizcli docker scan  --sensitive-data  --secrets --policy $(WIZ_POLICES) --image ifunky/site:latest 

scan/dockerfile: ## Scan dockerfile
	wizcli docker scan  --sensitive-data  --secrets --image ifunky/site:latest --dockerfile Dockerfile

scan/dir: ## Scan image
	wizcli dir scan  --sensitive-data  --secrets --policy $(WIZ_POLICES) --path .


delete: ## Deploy website
	@helm uninstall secsite-hugo \
		--namespace=ifunky 

run: ## Run site in docker
	echo "Goto http://localhost:8080/"
	docker run -p 8080:80 ifunky/site

push: ## Piush to docker repo
	@docker tag ifunky/site:latest ifunky/site:latest
	@docker push ifunky/site:latest