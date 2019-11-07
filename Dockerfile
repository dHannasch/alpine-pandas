FROM dahanna/python:3.7-cvxopt-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

  # https://github.com/openagua/alpine-glpk-python3
  # https://hub.docker.com/r/frolvlad/alpine-python-machinelearning/dockerfile
RUN apk add --no-cache --virtual build-base \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing py3-h5py \
    && apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing hdf5 \
    && apk add --no-cache --virtual hdf5-dev --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    # apk add --no-cache --virtual --repository http://dl-3.alpinelinux.org/alpine/edge/testing hdf5-dev results in ERROR: unsatisfiable constraints
    && apk info -a hdf5-dev \
    && echo "LD_LIBRARY_PATH is $LD_LIBRARY_PATH" \
    # https://pkgs.alpinelinux.org/contents?file=&path=&name=hdf5&branch=edge&repo=testing&arch=x86
    && ln -s /usr/lib/libhdf5.so.103 /usr/lib/libhdf5.so \
    && `gcc -print-prog-name=cc1plus` -v \
    # https://pkgs.alpinelinux.org/contents?repo=testing&page=2&arch=x86&branch=edge&name=hdf5-dev
    && find / -name hdf5.h
    && ls /usr/include/hdf5.h \
    && C_INCLUDE_PATH=/usr/include/ pip install --no-cache-dir --no-binary :all: hickle \
    # With or without --no-binary :all:, get Error loading shared library libhdf5.so: No such file or directory
    && python -c "import hickle" \
    && apk del --no-cache hdf5-dev build-base \
    && python -c "import hickle"
    # apk del reduced image size from 365MB to .

