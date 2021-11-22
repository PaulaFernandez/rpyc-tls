FROM python:3.8-slim-buster as python-base

    # python
ENV PYTHONUNBUFFERED=1 \
    # prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # poetry
    # https://python-poetry.org/docs/configuration/#using-environment-variables
    POETRY_VERSION=1.0.10 \
    # make poetry install to this location
    POETRY_HOME="/opt/poetry" \
    # do not create virtual environments
    POETRY_VIRTUALENVS_CREATE=false \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 

# Prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$PATH"

# `builder-base` stage is used to build deps + create our virtual environment
FROM python-base as builder-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        # deps for installing poetry
        curl \
        # deps for building python deps
        build-essential \
        # ssh-scan to add gitlab
        ssh \
        # git so we can install git dependencies
        git

# Install poetry - respects $POETRY_VERSION & $POETRY_HOME - and configure package repository credentials
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

# Copy project requirement files here to ensure they will be cached.
WORKDIR /app
COPY pyproject.toml poetry.lock ./

# Install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry update -vvv

COPY . /app

RUN poetry install

CMD python tpyc_tls/server.py


