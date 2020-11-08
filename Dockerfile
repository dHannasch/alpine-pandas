FROM dahanna/python-ray:ray-ubuntu

# libfreetype is fonds for matplotlib so we can make images of graphs
RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends llvm-dev libfreetype6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --no-cache-dir matplotlib \
    && python -c "import matplotlib" \
    && python -m pip install --no-cache-dir networkx \
    && python -c "import networkx" \
    && python -m pip install --no-cache-dir tox pytest

