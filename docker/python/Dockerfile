FROM python:3.9-alpine

LABEL maintainer="Oleg Tikhonov <to@toro.one>"
LABEL name="ethermine"

# Arguments

ARG USER_ID
ARG USER_NAME=ethermine
ARG USER_DIR=/home/ethermine

ENV ENV="${USER_DIR}/.profile"

# Dependencies

RUN apk add --update --no-cache --virtual .persistent \
    build-base \
    curl

# Working

WORKDIR ${USER_DIR}

COPY ./docker/create_user.sh ./create_user

RUN chmod +x ./create_user && ./create_user --id "${USER_ID}" --name "${USER_NAME}" --home "${USER_DIR}" \
    && rm -f ./create_user

USER ${USER_NAME}

RUN touch ~/.profile \
    && mkdir -p /home/ethermine/.venv \
    && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

COPY --chown=${USER_ID}:${USER_ID} . .
