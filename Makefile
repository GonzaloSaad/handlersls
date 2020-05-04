.PHONY: init \
init-venv \
update-venv \
clean \
clean-venv \
clean-pyc \
clean-test \
test \
coverage \

.DEFAULT_GOAL := help

# Python requirements
VENV ?= venv
REQUIREMENTS ?= requirements-dev.txt

help:
	@echo "    init"
	@echo "        Initialize development environment."
	@echo "    init-venv"
	@echo "        Initialize python environment."
	@echo "    update-venv"
	@echo "        Updates python environment."
	@echo "    clean"
	@echo "        Remove all the development environment files."
	@echo "    clean-venv"
	@echo "        Remove Python virtual environment."
	@echo "    clean-pyc"
	@echo "        Remove Python artifacts."
	@echo "    clean-test"
	@echo "        Remove Test data."
	@echo "    test"
	@echo "        Run pytest."
	@echo "    coverage"
	@echo "        Generate coverage report."

init: clean init-venv
	@echo ""
	@echo "Do not forget to activate your new virtual environment"

init-venv:
	@python3 -m venv $(VENV)
	@make update-venv

update-venv:
	@( \
		. $(VENV)/bin/activate; \
		pip install --upgrade setuptools pip; \
		pip install -r $(REQUIREMENTS); \
		pre-commit install; \
	)

clean: clean-pyc clean-test clean-venv clean-dist

clean-venv:
	@echo "Removing virtual environment: $(VENV)..."
	@rm -rf $(VENV)

clean-dist:
	@echo "Removing dist related files"
	@rm -rf ./dist
	@rm -rf ./serverless_sqs_handler.egg-info

clean-pyc:
	@echo "Removing compiled bytecode files..."
	@find . -name '*.pyc' -exec rm -f {} +
	@find . -name '*.pyo' -exec rm -f {} +
	@find . -name '*~' -exec rm -f {} +
	@find . -name '__pycache__' -exec rm -fr {} +

clean-test: clean-pyc
	@echo "Removing previous test data..."
	@rm -rf .coverage
	@rm -rf htmlcov
	@rm -rf .pytest_cache

test: clean-test
	pytest --disable-pytest-warnings

coverage: clean-test
	coverage run -m pytest --disable-pytest-warnings
	@coverage report
	@coverage html

build: clean-dist test
	@echo "Updating setuptools and wheel..."
	@python3 -m pip install --upgrade setuptools wheel
	@echo "Building package..."
	@python3 setup.py sdist

upload: build
	@twine upload --repository testpypi dist/*
