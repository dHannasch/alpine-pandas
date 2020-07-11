FROM dahanna/python-visualization:plotly-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

RUN apk add --no-cache --virtual build-base gcc musl-dev jpeg-dev zlib-dev \
    && pip install --no-cache-dir pillow \
    && python -c "import PIL.Image" \
    && apk del --no-cache build-base gcc musl-dev jpeg-dev zlib-dev \
    && apk add --no-cache jpeg zlib \
    && python -c "import PIL.Image"
    # apk del scipy-build build-base reduced image size from 274MB to 173MB.
    # apk del scipy-runtime did not decrease image size: it remained 173MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

