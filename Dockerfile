FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends python3-dev python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install --assume-yes build-essential \
    && python -m pip install --no-cache-dir ray[debug] \
    && python -c "import ray" \
    && apt-get purge --assume-yes build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
