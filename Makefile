ORG_CPU_IMAGE := bluexleoxgreen/ds-base:latest
ORG_GPU_IMAGE := bluexleoxgreen/ds-gpu-base:latest
TEST_IMAGE := bluexleoxgreen/test:latest
CPU_PORT := 50003
GPU_PORT := 50004


.PHONY: help
help: ## this is help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: build-image-cpu
build-image-cpu:  ## build a docker image
	docker build --build-arg UID=$(shell id -u) -t ${ORG_CPU_IMAGE} -f ./dockerfiles/cpu.Dockerfile .

.PHONY: build-image-gpu
build-image-gpu:  ## build a docker image
	docker build --build-arg UID=$(shell id -u) -t ${ORG_GPU_IMAGE} -f ./dockerfiles/gpu.Dockerfile .

.PHONY: build-test
build-test:  ## build image for test and lint
	docker build --build-arg UID=$(shell id -u) -t $(TEST_IMAGE) -f dockerfiles/test.Dockerfile .

.PHONY: run-notebook-cpu
run-notebook-cpu: build-image-cpu ## run notebook
	docker run -d --rm -v ${PWD}:/home -p ${CPU_PORT}:${CPU_PORT} --name notebook-cpu \
		${ORG_CPU_IMAGE} jupyter lab --port ${CPU_PORT} --ip=0.0.0.0 --allow-root --NotebookApp.token='' --NotebookApp.password=''

.PHONY: exec-notebook-cpu
exec-notebook-cpu: run-notebook-cpu
	docker exec -it notebook-cpu bash

.PHONY: run-notebook-gpu
run-notebook-gpu: build-image-gpu ## run notebook using gpu
	docker run -d --rm --gpus all -v ${PWD}:/home -p ${GPU_PORT}:${GPU_PORT} --name notebook-gpu \
		${ORG_GPU_IMAGE} jupyter lab --port ${GPU_PORT} --ip=0.0.0.0 --allow-root --NotebookApp.token='' --NotebookApp.password=''

.PHONY: exec-notebook-gpu
exec-notebook-gpu: run-notebook-gpu
	docker exec -it notebook-gpu bash

.PHONY: run-test
run-test: build-test  ## run test
	docker run -v ${PWD}:/work --rm $(TEST_IMAGE) pytest ./test/test.py

.PHONY: run-lint
run-lint: build-test ## lint using flake8
	docker run -v ${PWD}:/work --rm $(TEST_IMAGE) pysen run lint

.PHONY: run-auto-lint
run-auto-lint: build-test ## lint using flake8
	docker run --rm -v ${PWD}:/work $(TEST_IMAGE) pysen run format
