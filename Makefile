dev:
	jupyter notebook
.PHONY: dev


setup:
	git submodule update --init
	poetry install --no-root
.PHONY: setup
