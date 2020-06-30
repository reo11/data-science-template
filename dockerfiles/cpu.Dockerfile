FROM gcr.io/kaggle-images/python

COPY ./requirements/requirements.txt ./requirements.txt
RUN pip install -U pip && \
    pip install -r requirements.txt
