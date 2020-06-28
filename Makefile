CPU_IMAGE := gcr.io/kaggle-images/python:latest
GPU_IMAGE := gcr.io/kaggle-gpu-images/python:latest
ORG_IMAGE := bluexleoxgreen/ds-base:latest
TEST_IMAGE := bluexleoxgreen/python-lint-test:latest
CPU_PORT := 50000
GPU_PORT := 50001
ORG_PORT := 50002


.PHONY: help
help: ## this is help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: clean-pyc

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

.PHONY: jupyter-cpu
jupyter-cpu: clean  ## run jupyter
	docker run -v ${PWD}:/home -p ${CPU_PORT}:${CPU_PORT} \
		--rm ${CPU_IMAGE} jupyter lab --port ${CPU_PORT} --ip=0.0.0.0 --allow-root

.PHONY: jupyter-gpu
jupyter-gpu: clean  ## run jupyter using gpu
	docker run --gpus all -v ${PWD}:/home -p ${GPU_PORT}:${GPU_PORT} \
		--rm ${GPU_IMAGE} jupyter lab --port ${GPU_PORT} --ip=0.0.0.0 --allow-root

.PHONY: build-image
build-image: clean  ## build a docker image
	docker build -t ${ORG_IMAGE} -f ./dockerfiles/Dockerfile .

.PHONY: run-origin
run-origin: clean  ## run original jupyter
	docker run --gpus all -v ${PWD}:/home -p ${ORG_PORT}:${ORG_PORT} \
		--rm ${ORG_IMAGE} jupyter lab --port ${ORG_PORT} --ip=0.0.0.0 --allow-root

.PHONY: build-test
build-test:  ## build image for test and lint
	docker build -t $(TEST_IMAGE) -f dockerfiles/test.Dockerfile .

.PHONY: run-lint
run-lint: build-test  ## run lint
	@docker run -v ${PWD}:/work --rm $(TEST_IMAGE) flake8 .

.PHONY: run-auto-lint
run-auto-lint: build-test ## auto lint using flake8
	docker run -v ${PWD}:/work --rm $(TEST_IMAGE) ./test/autopep8.sh

.PHONY: run-test
run-test: build-test  ## run test
	docker run -v ${PWD}:/work --rm $(TEST_IMAGE) pytest ./test/test.py