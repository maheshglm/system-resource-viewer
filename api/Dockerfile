ARG IMAGE=python:3.8-slim-buster
FROM ${IMAGE}

LABEL maintainer="Mahesh maheshglm@gmail.com"

ENV GUNICORN_WORKERS=5

ARG GROUP_ID=3000
ARG USER_ID=1000
ARG GROUP_NAME=smart
ARG USER_NAME=smart

RUN pip install --upgrade pip && \
    pip install gunicorn

RUN addgroup --gid ${GROUP_ID} ${GROUP_NAME} && \
    adduser --home /home/${USER_NAME} --gid ${GROUP_ID} --uid ${USER_ID} ${USER_NAME}

USER ${USER_NAME}

WORKDIR /home/${USER_NAME}

COPY --chown=${GROUP_NAME}:${USER_NAME} requirements.txt  app.py ./

RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD gunicorn --workers $GUNICORN_WORKERS --bind 0.0.0.0:5000 app:app