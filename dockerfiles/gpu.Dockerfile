FROM gcr.io/kaggle-gpu-images/python

ARG UID
RUN useradd reo -u $UID -m
USER reo

COPY ./requirements/requirements.txt ./requirements.txt
RUN pip install -U pip && \
    pip install -r requirements.txt
