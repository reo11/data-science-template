FROM gcr.io/kaggle-gpu-images/python

# Install extra libs
COPY ./requirements.txt ./requirements.txt
RUN pip install -U pip && \
    pip install -r requirements.txt