FROM alpine:edge

# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# It used to be possible to compile SciPy from source on Alpine
# (see dahanna/python:3.7-scipy-alpine)
# but this doesn't seem to be possible anymore.
# pip install scipy mysteriously fails to compile even after all apparent error messages are resolved.

# Without musl-dev, fails saying cannot find crti.o: No such file or directory
# https://pkgs.alpinelinux.org/contents?file=crti.o&branch=v3.12 turned up musl-dev
# RUN apk add --no-cache --virtual g++ openblas-dev lapack-dev musl-dev freetype-dev pkgconfig gfortran build-base libpng-dev libexecinfo-dev libgomp libgcc libquadmath \
#    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
#    && pip install --no-cache-dir scipy \
#    && python -c "import scipy" \
#    && apk del --no-cache g++ openblas-dev lapack-dev musl-dev freetype-dev pkgconfig gfortran build-base libpng-dev libexecinfo-dev libgomp libgcc libquadmath \
#    && apk add --no-cache openblas \
#    && python -c "import scipy"

# However, the available packages seem to have matured to the point they can be used
# instead of the python:alpine hand-built images.

RUN apk add --no-cache python3-dev git

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

