FROM dahanna/python-alpine-floating-version:pandas-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.
# The --no-cache option means to not cache the index locally, which is useful for keeping containers small.
# --no-cache equals apk update in the beginning and rm -rf /var/cache/apk/* in the end.

# Building llvmlite requires LLVM 9.0.x, Alpine 3.10 only has llvm8 available
# RuntimeError: Building llvmlite requires LLVM 9.0.x, got '10.0.0'.
RUN apk --no-cache search --verbose '*llvm*'
RUN apk --no-cache add --virtual build-base g++ musl-dev llvm9-dev \
    && find / -name *llvm* \
    && LLVM_CONFIG=/usr/lib/llvm9/bin/llvm-config pip install --no-cache-dir numba \
    && python -c "import numba" \
    && apk del --no-cache build-base g++ musl-dev llvm9-dev \
    && python -c "import numba"
    # apk del reduced image size from 365MB to .

