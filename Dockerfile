# FROM dahanna/python-alpine-package:pandas-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

FROM jeffutter/python-opencv-alpine

# RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ opencv-dev
# RUN pip install --no-cache-dir scikit-build
# pip install opencv-python yields ModuleNotFoundError: No module named 'skbuild'
# RUN apk --update add --no-cache --virtual opencv-python-build-dependencies cmake ninja libressl-dev gfortran g++ openblas-dev lapack-dev \
#    && OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so CMAKE_USE_OPENSSL=OFF pip install --no-cache-dir opencv-python \
#    && apk del --no-cache opencv-python-build-dependencies \
#    && apk --update add --no-cache openblas lapack libstdc++ \
    # apk add libstdc++ fixes ImportError: Error loading shared library libstdc++.so.6: No such file or directory
    # apk add openblas fixes ImportError: Error loading shared library libopenblas.so.3: No such file or directory
#    && python -c "import cv2"
