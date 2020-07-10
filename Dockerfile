FROM dahanna/python-alpine-floating-version:tox-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

# apk add subversion to fix /bin/sh: svnversion: not found
# apk add gfortran to fix Could not locate executable gfortran
# apk add openblas-dev to fix Blas libraries are not found.
RUN apk --update add --no-cache --virtual subversion gfortran g++ openblas-dev \
    && pip install --no-cache-dir pandas \
    && apk del --no-cache subversion gfortran g++ openblas-dev \
    && apk --update add --no-cache openblas libstdc++
    # apk add libstdc++ fixes ImportError: Error loading shared library libstdc++.so.6: No such file or directory
    # apk add openblas fixes ImportError: Error loading shared library libopenblas.so.3: No such file or directory
    && python -c "import pandas"
    # Adding --no-cache-dir to pip install reduced image size from 226.67MB to 208MB.
    # apk del subversion gfortran reduced image size from 208MB to 98.89MB.
