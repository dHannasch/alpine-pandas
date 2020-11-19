FROM dahanna/python-alpine-package:pandas-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ opencv-dev
RUN pip install --no-cache-dir scikit-build
# pip install opencv-python yields ModuleNotFoundError: No module named 'skbuild'
RUN apk --update add --no-cache --virtual opencv-python-build-dependencies build-base abuild binutils cmake cmake-extras extra-cmake-modules ninja libressl-dev gfortran g++ openblas-dev lapack-dev libuv-dev \
    && pip install --no-cache-dir pyuv \
    && apk --update add --no-cache --virtual cmake-dependencies tar gzip \
    && pip download --no-cache-dir cmake \
    && ls cmake-*.tar.gz \
    && tar --extract --gunzip --file cmake-*.tar.gz \
    && rm cmake-*.tar.gz \
    && ls cmake-* \
    # && OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so CMAKE_USE_OPENSSL=OFF USE_OPENSSL=OFF pip install --no-cache-dir opencv-python-headless \
    && cd cmake-* \
    # && cmake -D OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so \
    # && OPENSSL_ROOT_DIR=/usr/include/openssl/ OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so cmake \
    && OPENSSL_ROOT_DIR=/usr/include/openssl/ OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so cmake -DOPENSSL_INCLUDE_DIR=/usr/include/openssl/ -DOPENSSL_SSL_LIBRARY=/usr/lib/libssl.so -DOPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so -DCMAKE_USE_OPENSSL=OFF \
    && pip install . \
    && cd .. \
    && echo "about to pip install cmake" \
    && OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so CMAKE_USE_OPENSSL=OFF USE_OPENSSL=OFF pip install --no-cache-dir cmake \
    && echo "done pip install cmake" \
    && OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so CMAKE_USE_OPENSSL=OFF USE_OPENSSL=OFF pip install --no-cache-dir opencv-python-headless \
    && apk del --no-cache opencv-python-build-dependencies \
    && apk --update add --no-cache openblas lapack libstdc++ \
    # apk add libstdc++ fixes ImportError: Error loading shared library libstdc++.so.6: No such file or directory
    # apk add openblas fixes ImportError: Error loading shared library libopenblas.so.3: No such file or directory
    && python -c "import cv2"


# hack to get this working:

# FROM jeffutter/python-opencv-alpine

# RUN python -c "import cv2"

# RUN apk --update add --no-cache --virtual subversion gfortran g++ openblas-dev \
#    && pip install --no-cache-dir pandas \
#    && apk del --no-cache subversion gfortran g++ openblas-dev \
#    && apk --update add --no-cache openblas libstdc++ \
    # apk add libstdc++ fixes ImportError: Error loading shared library libstdc++.so.6: No such file or directory
    # apk add openblas fixes ImportError: Error loading shared library libopenblas.so.3: No such file or directory
#    && python -c "import pandas"
    # Adding --no-cache-dir to pip install reduced image size from 226.67MB to 208MB.
    # apk del subversion gfortran reduced image size from 208MB to 98.89MB.


