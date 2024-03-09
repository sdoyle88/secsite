.SHELL := /usr/bin/bash
.EXPORT_ALL_VARIABLES:

export TF_IN_AUTOMATION = 1
export README_INCLUDES ?= $(file://$(shell pwd)/?type=text/plain)


help:
	@grep -E '^[a-zA-Z_-_\/]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy: ## Deploy website
	@helm upgrade secsite-hugo ./chart \
		--namespace=secsite \
		--create-namespace \
		--wait \
		--install \
		--values chart/values.yaml \
		--set image.repository=ifunky/site \
		--set image.tag=latest

