FROM dahanna/python.3.7-pandas-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

RUN apk --update add --no-cache --virtual scipy-runtime \
    && apk add --no-cache --virtual scipy-build build-base openblas-dev freetype-dev pkgconfig gfortran \
    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
    && pip install --no-cache-dir scipy \
    && apk del --no-cache scipy-build build-base freetype-dev pkgconfig gfortran \
    && apk del --no-cache scipy-runtime
    # apk del scipy-build build-base reduced image size from 274MB to 173MB.
    # apk del scipy-runtime did not decrease image size: it remained 173MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

