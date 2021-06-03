FROM gcr.io/kaggle-gpu-images/python

COPY ./requirements/test.requirements.txt /tmp/requirements.txt

RUN pip install -U pip && \
    pip install -r /tmp/requirements.txt --no-warn-script-location

ARG UID
ARG UNAME
RUN useradd $UNAME -u $UID -m
USER $UNAME

WORKDIR /home/$UNAME

ENV PYTHONPATH ${PYTHONPATH}:${PWD}
