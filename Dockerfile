FROM dahanna/python.3.7-pandas-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

RUN apk --update add --no-cache --virtual scipy-runtime
RUN apk add --no-cache --virtual scipy-build build-base python-dev openblas-dev freetype-dev pkgconfig gfortran

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN pip install --no-cache-dir scipy

RUN apk del scipy-runtime scipy-build build-base
