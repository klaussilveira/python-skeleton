NAME := $(shell cat pyproject.toml | sed -n 's/^name = "\(.*\)"/\1/p')
VERSION := $(shell cat pyproject.toml | sed -n 's/^version = "\(.*\)"/\1/p')

help: # Display the application manual
	@echo -e "$(NAME) version \033[33m$(VERSION)\n\e[0m"
	@echo -e "\033[1;37mUSAGE\e[0m"
	@echo -e "  \e[4mmake\e[0m <command> [<arg1>] ... [<argN>]\n"
	@echo -e "\033[1;37mAVAILABLE COMMANDS\e[0m"
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "  \033[32m%-20s\033[0m %s\n", $$1, $$2}'

format: clean # Run code style autoformatter
	@poetry run black app.py app/ tests/

setup: check_deps # Install dependencies and development configuration
	@poetry install
	@poetry run pre-commit install

test: # Run automated test suite
	@poetry run pytest tests/ -sq
	@poetry run pre-commit run --all-files

build: # Build application package
	@poetry build -v

publish: # Publish application package to remote repository
	@poetry publish

clean: # Cleanup temporary files and build artifacts
	@rm -rf build dist .eggs *.egg-info
	@rm -rf .benchmarks .coverage coverage.xml htmlcov report.xml
	@find . -type d -name '.mypy_cache' -exec rm -rf {} +
	@find . -type d -name '__pycache__' -exec rm -rf {} +
	@find . -type d -name '*pytest_cache*' -exec rm -rf {} +
	@find . -type f -name "*.py[co]" -exec rm -rf {} +

check_deps:
	@if ! [ -x "$$(command -v poetry)" ]; then\
	  echo -e '\n\033[0;31mpoetry is not installed.';\
	  exit 1;\
	else\
	  echo -e "\033[0;32mpoetry installed\033[0m";\
	fi

.PHONY: help
.DEFAULT_GOAL := help
