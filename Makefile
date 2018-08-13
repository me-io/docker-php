.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "Available tasks:"
	@echo "    lint                 Run linter and code style checker"
	@echo "    unit                 Run unit tests and generate"
	@echo "    unit-cov             Run unit tests and generate coverage"
	@echo "    unit-html            Run unit tests and generate coverage, html"
	@echo "    test                 Run linter and unit tests"
	@echo "    watch                Run linter and unit tests when any of the source files change"
	@echo "    all                  Install dependencies and run linter and unit tests"
	@echo ""

mac-install-dep:
	brew install php72 php72-igbinary php72-mongodb php72-xdebug php72-redis mongodb

linux-install-dep:
	brew install php72 php72-igbinary php72-mongodb php72-xdebug php72-redis mongodb

unit-cov:
	vendor/bin/phpunit --coverage-text --coverage-clover=coverage.xml

unit-html:
	vendor/bin/phpunit --coverage-text --coverage-clover=coverage.xml --coverage-html=./report/

test: lint unit

travis: lint unit

all: deps-install-dev test

.PHONY: help lint unit unit-html test travis all
