FROM pythonpackagesonalpine/basic-python-packages-pre-installed-on-alpine:tox-alpine

RUN apk add --no-cache clang g++ linux-headers curl unzip psmisc \
    && apk add --no-cache cython py3-numpy py3-pytest

