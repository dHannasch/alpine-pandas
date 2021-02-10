FROM dahanna/python-alpine-package:tox-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

RUN apk add --no-cache bazel --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN apk add --no-cache g++ curl unzip psmisc \
    && apk add --no-cache cython
RUN apk add --no-cache grpc \
    && pip install grpcio
RUN git clone https://github.com/ray-project/ray.git \
    && cd ray/python \
    && pip install --editable . --verbose
# RUN python -m pip install --no-cache-dir ray[debug] --verbose
