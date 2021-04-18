FROM dahanna/python-ray:ray-deps-alpine

RUN /usr/bin/python --version \
    && python -c "import grpc; print(grpc.__version__)" \
    && rm /usr/bin/python \
    && apk add --no-cache python2 \
    && cd ray/python \
    && BAZEL_PATH=/usr/bin/bazel-real pip install --no-build-isolation --editable . --verbose
# RUN python -m pip install --no-cache-dir ray[debug] --verbose
