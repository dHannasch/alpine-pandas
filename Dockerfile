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

# Install Pandoc
ENV PANDOC_VERSION 2.7.2
ENV PANDOC_DOWNLOAD_URL https://github.com/jgm/pandoc/archive/$PANDOC_VERSION.tar.gz
ENV PANDOC_DOWNLOAD_SHA512 4b3a21cf76777ed269bf7c13fd09ab1d5c97ed21ec9f02bff95fd3641ac9d52bde19a6e2ffb325378e611dfbe66b8b00769d8510a8b2fb1dfda8062d79b12233
ENV PANDOC_ROOT /usr/local/pandoc
ENV PATH $PATH:$PANDOC_ROOT/bin

RUN apk add --no-cache \
    gmp \
    libffi \
 && apk add --no-cache --virtual build-dependencies \
    --repository "http://nl.alpinelinux.org/alpine/edge/community" \
    ghc \
    cabal \
    linux-headers \
    musl-dev \
    zlib-dev \
    curl \
 && mkdir -p /pandoc-build && cd /pandoc-build \
 && curl -fsSL "$PANDOC_DOWNLOAD_URL" -o pandoc.tar.gz \
 && echo "$PANDOC_DOWNLOAD_SHA512  pandoc.tar.gz" | sha512sum -c - \
 && tar -xzf pandoc.tar.gz && rm -f pandoc.tar.gz \
 && ( cd pandoc-$PANDOC_VERSION && cabal update && cabal install --only-dependencies \
    && cabal configure --prefix=$PANDOC_ROOT \
    && cabal build \
    && cabal copy \
    && cd .. ) \
 && rm -Rf pandoc-$PANDOC_VERSION/ \
 && apk del --purge build-dependencies \
 && rm -Rf /root/.cabal/ /root/.ghc/ \
 && cd / && rm -Rf /pandoc-build

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

