.PHONY: help version metadata terragrunt-plan package
	.DEFAULT_GOAL := help

export TF_ROOT_MODULE :=./terraform/live/jupyter-notebook

export PATH := $(PWD)/bin:$(PATH)

help: ## show this message
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dependencies: ## install dependencies and setup local environment
	./scripts/terraform-helpers.sh tfenv
	./scripts/terraform-helpers.sh terragrunt

terragrunt-init: ## runs terragrunt init on the root module
	cd $$TF_ROOT_MODULE && terragrunt init

terragrunt-plan: terragrunt-init ## runs terragrunt plan
	cd $$TF_ROOT_MODULE && terragrunt plan

terragrunt-apply: terragrunt-init ## runs terragrunt apply
	cd $$TF_ROOT_MODULE && terragrunt apply -auto-approve

terragrunt-destroy: terragrunt-init ## runs terragrunt destroy
	cd $$TF_ROOT_MODULE && terragrunt destroy -auto-approve

terragrunt-output: terragrunt-init ## runs terragrunt output
	cd $$TF_ROOT_MODULE && terragrunt output 2>/dev/null
