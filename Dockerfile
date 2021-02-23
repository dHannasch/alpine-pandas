# FROM dahanna/python-alpine-package:pandas-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

# RUN pip install --no-cache-dir --upgrade pip setuptools wheel
# RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ opencv-dev
# RUN pip install --no-cache-dir scikit-build
#   pip install opencv-python yields ModuleNotFoundError: No module named 'skbuild'
# RUN apk --update add --no-cache --virtual opencv-python-build-dependencies build-base abuild binutils cmake cmake-extras extra-cmake-modules ninja libressl-dev gfortran g++ openblas-dev lapack-dev libuv-dev \
#    && pip install --no-cache-dir pyuv \
#    && apk --update add --no-cache --virtual cmake-dependencies tar gzip \
#    && pip download --no-cache-dir cmake \
#    && ls cmake-*.tar.gz \
#    && tar --extract --gunzip --file cmake-*.tar.gz \
#    && rm cmake-*.tar.gz \
#    && ls cmake-* \
    # && OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so CMAKE_USE_OPENSSL=OFF USE_OPENSSL=OFF pip install --no-cache-dir opencv-python-headless \
#    && cd cmake-* \
    # && cmake -D OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so \
    # && OPENSSL_ROOT_DIR=/usr/include/openssl/ OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so cmake \
#    && OPENSSL_ROOT_DIR=/usr/include/openssl/ OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so cmake -DOPENSSL_INCLUDE_DIR=/usr/include/openssl/ -DOPENSSL_SSL_LIBRARY=/usr/lib/libssl.so -DOPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so -DCMAKE_USE_OPENSSL=OFF \
#    && pip install . \
#    && cd .. \
#    && echo "about to pip install cmake" \
#    && OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so CMAKE_USE_OPENSSL=OFF USE_OPENSSL=OFF pip install --no-cache-dir cmake \
#    && echo "done pip install cmake" \
#    && OPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so CMAKE_USE_OPENSSL=OFF USE_OPENSSL=OFF pip install --no-cache-dir opencv-python-headless \
#    && apk del --no-cache opencv-python-build-dependencies \
#    && apk --update add --no-cache openblas lapack libstdc++ \
    # apk add libstdc++ fixes ImportError: Error loading shared library libstdc++.so.6: No such file or directory
    # apk add openblas fixes ImportError: Error loading shared library libopenblas.so.3: No such file or directory
#    && python -c "import cv2"


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


# jjanzic/docker-python3-opencv works!
# but we'd still like to be able to install on a newer version...
# FROM jjanzic/docker-python3-opencv

# RUN pip install --upgrade pip
# RUN pip install --no-cache-dir tox
# RUN pip install --no-cache-dir pandas rasterio scikit-image tqdm


FROM pythonpackagesonalpine/basic-python-packages-pre-installed-on-alpine:pip-alpine

# python-opencv specifically requires that you not already have opencv installed, but we can use the Alpine package to install dependencies of opencv.
# apk del also removes all the dependencies, so we need to install them manually.
# https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/testing/opencv/APKBUILD

# pip install cmake is just a fancy way of installing cmake,
# with --no-build-isolation we can just apk add cmake:
# https://cliutils.gitlab.io/modern-cmake/chapters/intro/installing.html
# https://cmake-python-distributions.readthedocs.io/en/latest/installation.html#install-package-with-pip

RUN apk add --no-cache py3-numpy-dev \
    && pip install --no-cache-dir scikit-build \
    && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --virtual .build-deps blas-dev cmake eigen-dev ffmpeg-dev freetype-dev glew-dev gstreamer-dev harfbuzz-dev hdf5-dev lapack-dev libdc1394-dev libgphoto2-dev libtbb-dev mesa-dev openexr-dev openjpeg-dev openjpeg-tools qt5-qtbase-dev vtk-dev ninja make g++ openssl-dev libpng-dev \
    # pip install opencv-python says GStreamer: NO despite having gstreamer-dev installed
    # gstreamer-dev should also install glib-dev yet ocv_check_modules(GSTREAMER_base): can't find library 'glib-2.0'.
    # ocv_check_modules(GSTREAMER_base): can't find library 'gobject-2.0'.
    # ocv_check_modules(GSTREAMER_base): can't find library 'gstbase-1.0'.
    # ocv_check_modules(DC1394_2): can't find library 'dc1394'. despite apk add libdc1394-dev
    # ocv_check_modules(FFMPEG_libavresample): can't find library 'avresample'.
    # ocv_check_modules(FFMPEG): can't find library 'swscale'.
    # ocv_check_modules(FFMPEG): can't find library 'avutil'.
    # ocv_check_modules(FFMPEG): can't find library 'avformat'.
    # ocv_check_modules(FFMPEG): can't find library 'avcodec'.
    # ocv_check_modules(GTHREAD): can't find library 'intl'.
    # apk add musl-libintl results in musl-libintl-1.2.2-r1: trying to overwrite usr/include/libintl.h owned by gettext-dev
    # ocv_check_modules(GTHREAD): can't find library 'gthread-2.0'.
    # Could NOT find PNG (missing: PNG_LIBRARY) (found version "1.6.37")
    # --no-build-isolation should allow using the installed numpy so it doesn't try to install another numpy
    && pip install --no-cache-dir --no-build-isolation opencv-python \
    && apk del --no-cache .build-deps \
    && apk add --no-cache openjpeg


