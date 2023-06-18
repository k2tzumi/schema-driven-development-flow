.DEFAULT_GOAL := help

REPOSITORY := $(notdir $(CURDIR))

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build slide
build: dist/index.html

.PHONY: pdf
pdf: ## Export PDF
pdf: slides-export.pdf

.PHONY: dev
dev: ## Run dev server
dev: node_modules
	npm run dev

dist/index.html: node_modules
	npm run build

slides-export.pdf: node_modules
	npm run export

node_modules: package.json package-lock.json
	npm ci

.PHONY: install
install: ## Install packages
install: node_modules

.PHONY: upgrade
upgrade: ## Upgrades package.json
upgrade:
	npx -p npm-check-updates  -c "ncu -u"
	npm update

.PHONY: publish
publish: ## Publish slide
publish: slides-export.pdf
	npx -p @slidev/cli  -c "slidev build --base /$(REPOSITORY) --out docs"

.PHONY: clean
clean: ## Delete slide
clean:
	rm -rf docs dist slides-export.pdf