FROM ubuntu-latest

RUN apt-get install --assume-yes python3-dev \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get install --assume-yes gcc \
    && python -m pip install --no-cache-dir ray[debug] \
    && apt-get remove --assume-yes gcc \
    && rm -rf /var/lib/apt/lists/*
