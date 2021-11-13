#!/usr/bin/make

SHELL := /bin/bash

.PHONY : help init up down install serve serve-quiet app-cli
.DEFAULT_GOAL : help

DOCKER_ENV_FILE = .env

ifneq ("$(wildcard $(DOCKER_ENV_FILE))","")
    include $(DOCKER_ENV_FILE)
endif

help: ## Show this help
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "  \033[32m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## First command
	@if [ ! -f $(DOCKER_ENV_FILE) ]; \
	then \
		cp $(DOCKER_ENV_FILE).example $(DOCKER_ENV_FILE); \
		sed -i -e 's/HOST_FILES_OWNER_UID=.*/HOST_FILES_OWNER_UID=$(shell id -u)/' \
			-e 's/HOST_FILES_OWNER_NAME=.*/HOST_FILES_OWNER_NAME=$(USER)/' $(DOCKER_ENV_FILE); \
	fi;

up: ## Up containers
	@docker-compose --env-file $(DOCKER_ENV_FILE) up -d

down: ## Stops containers and removes containers, networks, volumes, and images created by Up
	@docker-compose down

install: ## Run install for development
	$(call check_env,$(DOCKER_ENV_FILE))
	@docker-compose --env-file $(DOCKER_ENV_FILE) up -d --build
	@docker exec -it $(COMPOSE_PROJECT_NAME)_app /bin/bash -c \
	"composer create-project laravel/laravel tmp '$(LARAVEL_VERSION)' --prefer-dist \
		&& mv -n tmp/{,.}* . \
		&& rm -rf tmp \
		&& sed -i -e 's/APP_NAME=.*/APP_NAME=$(COMPOSE_PROJECT_NAME)/' \
		 -e 's/APP_NAME=.*/APP_NAME=$(COMPOSE_PROJECT_NAME)/' \
		 -e 's/DB_DATABASE=.*/DB_DATABASE=$(MYSQL_DATABASE)/' \
		 -e 's/DB_USERNAME=.*/DB_USERNAME=$(MYSQL_USER)/' \
		 -e 's/DB_PASSWORD=.*/DB_PASSWORD=$(MYSQL_PASSWORD)/' \
		 -e 's/DB_HOST=.*/DB_HOST=database/' .env \
		&& composer require orchid/platform:$(ORCHID_VERSION) \
		&& php artisan orchid:install"

serve: ## Run server
	@docker exec -it $(COMPOSE_PROJECT_NAME)_app /bin/bash -c \
		"php artisan serve --host=0.0.0.0 --port=80"

serve-quiet: ## Run server in detach mode
	@docker exec -d $(COMPOSE_PROJECT_NAME)_app /bin/bash -c \
		"php artisan serve --host=0.0.0.0 --port=80"

app-cli: ## Connect to app container
	@docker exec -it $(COMPOSE_PROJECT_NAME)_app /bin/bash

# --- [ Functions ] ----------------------------------------------------------------------------------------------------
check_env = \
	@if [ ! -f $(1) ]; \
	then \
		echo "File $(1) not found"; \
		exit 1; \
	fi;