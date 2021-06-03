FROM python:3.7.10

ARG UID
RUN useradd reo -u $UID -m
USER reo

WORKDIR /work

COPY ./requirements/test.requirements.txt ./requirements.txt

RUN pip install -U pip && \
    pip install -r requirements.txt

