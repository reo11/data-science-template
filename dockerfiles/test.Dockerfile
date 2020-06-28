FROM python:3.8.3-buster

WORKDIR /work

COPY ./requirements/test.requirements.txt ./requirements.txt

RUN pip install -U pip && \
    pip install -r requirements.txt