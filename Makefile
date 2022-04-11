dev:
	jupyter notebook
.PHONY: dev


setup:
	pip install git+https://github.com/qiskit-community/qiskit-textbook.git#subdirectory=qiskit-textbook-src
	pip install pylatexenc
.PHONY: setup
