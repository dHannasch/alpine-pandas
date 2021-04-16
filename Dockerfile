FROM pythonpackagesonalpine/basic-python-packages-pre-installed-on-alpine:tox-alpine

RUN apk add --no-cache bazel --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN apk add --no-cache clang g++ linux-headers curl unzip psmisc \
    && apk add --no-cache cython py3-numpy

