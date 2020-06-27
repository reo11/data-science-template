CPU_IMAGE := gcr.io/kaggle-images/python:latest
GPU_IMAGE := gcr.io/kaggle-gpu-images/python
ORIGINAL_IMAGE := bluexleoxgreen/ds-base
PORT := 19000

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

.PHONY: jupyter-gpu
jupyter-gpu: clean  ## run jupyter using gpu
	docker run --gpus all -v ${PWD}:/home -p ${PORT}:${PORT} \
		--rm ${GPU_IMAGE} jupyter lab --port ${PORT} --ip=0.0.0.0 --allow-root

.PHONY: jupyter-cpu
jupyter-cpu: clean  ## run jupyter
	docker run -v ${PWD}:/home -p ${PORT}:${PORT} \
		--rm ${CPU_IMAGE} jupyter lab --port ${PORT} --ip=0.0.0.0 --allow-root

.PHONY: build-image
build-image: clean  ## build a docker image
	docker build -t ${ORIGINAL_IMAGE} .

.PHONY: run-origin
run-origin: clean  ## run jupyter
	docker run --gpus all -v ${PWD}:/home -p ${PORT}:${PORT} \
		--rm ${ORIGINAL_IMAGE} jupyter lab --port ${PORT} --ip=0.0.0.0 --allow-root

