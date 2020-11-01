FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get install --assume-yes gcc \
    && python -m pip install --no-cache-dir ray[debug] \
    && apt-get remove --assume-yes gcc \
    && rm -rf /var/lib/apt/lists/*
