clean:
	@rm -rf `find . -name __pycache__`
	@make -C docs clean

install:
	@pip install -U pip setuptools
	@pip install -Ur requirements-dev.txt

.PHONY: clean
