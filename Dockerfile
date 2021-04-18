FROM dahanna/python-ray:ray-deps-alpine

RUN /usr/bin/python --version \
    && cd ray/python \
    && BAZEL_PATH=/usr/bin/bazel-real pip install --no-build-isolation --editable . --verbose
# RUN python -m pip install --no-cache-dir ray[debug] --verbose
