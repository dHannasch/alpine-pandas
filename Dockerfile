FROM dahanna/python-ray:ray-ubuntu

RUN python -m pip install --no-cache-dir matplotlib \
    && python -c "import matplotlib" \
    && python -m pip install --no-cache-dir networkx \
    && python -c "import networkx" \
    && python -m pip install --no-cache-dir tox pytest
RUN apt-get install --assume-yes llvm-dev libfreetype6-dev
