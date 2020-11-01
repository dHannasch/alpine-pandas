FROM dahanna/ray:ray-ubuntu

RUN python -m pip install --no-cache-dir matplotlib \
    && python -c "import matplotlib" \
    && python -m pip install --no-cache-dir networkx \
    && python -c "import networkx"

