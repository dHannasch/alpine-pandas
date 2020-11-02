FROM dahanna/ubuntu:wget

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends python3-dev python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install --assume-yes build-essential \
    && python -m pip install --no-cache-dir ray[debug] \
    && ray install-nightly \
    && python -m pip install --no-cache-dir ray[debug] \
    # && python -m pip install --no-cache-dir https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-1.1.0.dev0-cp38-cp38-manylinux1_x86_64.whl \
    && apt-get purge --assume-yes build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python -c "import ray"
