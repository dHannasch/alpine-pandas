FROM dahanna/python-ray:grpcio-alpine

RUN git clone https://github.com/ray-project/ray.git \
    && cd ray/python \
    && pip install --editable . --verbose
# RUN python -m pip install --no-cache-dir ray[debug] --verbose
