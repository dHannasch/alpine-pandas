FROM dahanna/python:3.7-scipy-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

RUN apk add --no-cache libzmq \
    && apk add --no-cache --virtual build-base g++ musl-dev zeromq-dev \
    && pip install --no-cache-dir pyzmq \
    && python -c "import zmq" \
    && apk del --no-cache build-base g++ musl-dev zeromq-dev \
    && python -c "import zmq" \
# https://stackoverflow.com/questions/51915174/how-to-install-pyzmq-on-a-alpine-linux-container
# python:3.6-alpine does not install Python via apk, it has Python built from source and located under /usr/local. So when you inherit from python:3.6-alpine, install python3-dev and run pip install pyzmq, you'll end up with building pyzmq for Python 3.6.6 (coming from python:3.6-alpine) using header files from Python 3.6.4 (coming from apk add python3-dev).

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

