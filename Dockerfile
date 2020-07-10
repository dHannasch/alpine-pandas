FROM dahanna/python:3.7-pillow-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

RUN apk add --no-cache --virtual llvm-dev \
    && pip install --no-cache-dir numba \
    && python -c "import numba" \
    && apk del --no-cache llvm-dev \
    && python -c "import numba"
    # apk del reduced image size from 365MB to .

