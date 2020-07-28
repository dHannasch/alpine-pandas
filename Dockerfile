FROM dahanna/python-visualization:dash-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

ARG ARROW_BUILD_TYPE=release

ENV ARROW_HOME=/usr/local
ENV PARQUET_HOME=/usr/local

#Download and build apache-arrow
# unsatisfiable constraints: thrift-dev
RUN apk --no-cache add --virtual build-base g++ cmake make boost-dev py3-numpy-dev gflags-dev rapidjson-dev zlib-dev \
    && git clone https://github.com/apache/arrow.git /arrow \
    && mkdir --parents /arrow/cpp/build \
    && cd /arrow/cpp/build \
    && ls /usr/lib/python3.8/site-packages/numpy/core/include/ \
    && cmake -DCMAKE_BUILD_TYPE=$ARROW_BUILD_TYPE \
          -DCMAKE_INSTALL_LIBDIR=lib \
          -DCMAKE_INSTALL_PREFIX=$ARROW_HOME \
          -DARROW_PARQUET=on \
          -DARROW_PYTHON=on \
          -DARROW_PLASMA=on \
          -DARROW_BUILD_TESTS=OFF \
          -DPython3_NumPy_INCLUDE_DIRS=/usr/lib/python3.8/site-packages/numpy/core/include/ \
          .. \
    && make \
    && make install \
    && cd /arrow/python \
    && python setup.py build_ext --build-type=$ARROW_BUILD_TYPE --with-parquet \
    && python setup.py install \
    && rm -rf /arrow \
    && apk --no-cache del build-base g++ cmake make boost-dev py3-numpy-dev sgflags-dev rapidjson-dev zlib-dev \
    && python -c "import pyarrow"

