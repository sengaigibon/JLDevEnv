COMPOSE   = podman compose
APP       = $(COMPOSE) exec app
CONSOLE   = $(APP) php bin/console
COMPOSER  = $(APP) composer

.DEFAULT_GOAL := help

# ── Infrastructure ───────────────────────────────────────────

up: ## Start and build containers (detached)
	$(COMPOSE) up -d 

up-build: ## Start and build containers (detached)
	$(COMPOSE) up -d --build

down: ## Stop and remove containers
	$(COMPOSE) down

restart: down up ## Restart all containers

shell: ## Open a shell inside the app container
	$(APP) sh

# ── Composer ─────────────────────────────────────────────────

install: ## Install Composer dependencies
	$(COMPOSER) install 

update: ## Update Composer dependencies
	$(COMPOSER) update

# ── Symfony Console ───────────────────────────────────────────

cache-clear: ## Clear Symfony cache
	$(CONSOLE) cache:clear

cache-warmup: ## Warm up Symfony cache
	$(CONSOLE) cache:warmup

routes: ## List all registered routes
	$(CONSOLE) debug:router

services: ## List all registered services
	$(CONSOLE) debug:container

# ── Database ─────────────────────────────────────────────────

db-create: ## Create the database
	$(CONSOLE) doctrine:database:create --if-not-exists

db-migrate: ## Run migrations
	$(CONSOLE) doctrine:migrations:migrate

db-diff: ## Generate a migration from entity changes
	$(CONSOLE) doctrine:migrations:diff

db-fixtures: ## Load fixtures
	$(CONSOLE) doctrine:fixtures:load


# ── Tests ─────────────────────────────────────────────────────

test: ## Run all tests
	$(APP) php bin/phpunit

test-unit: ## Run unit tests only
	$(APP) php bin/phpunit --testsuite=unit

test-functional: ## Run functional tests only
	$(APP) php bin/phpunit --testsuite=functional

# ── Maker Bundle ─────────────────────────────────────────────

make-entity: ## Create/update an entity
	$(CONSOLE) make:entity

make-controller: ## Create a controller
	$(CONSOLE) make:controller

make-migration: ## Generate a migration
	$(CONSOLE) make:migration

make-form: ## Create a form type
	$(CONSOLE) make:form

make-test: ## Create a test class
	$(CONSOLE) make:test

# ── Help ──────────────────────────────────────────────────────

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'
