FROM dahanna/python-ray:grpcio-alpine

RUN git clone https://github.com/ray-project/ray.git \
    && ray/ci/travis/install-bazel.sh

