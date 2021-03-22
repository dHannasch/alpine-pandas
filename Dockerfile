FROM pythonpackagesonalpine/python-visualization-alpine:matplotlib-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

RUN apk add --no-cache tesseract-ocr py3-numpy imagemagick \
    && pip install --upgrade pip setuptools wheel \
    && apk add --no-cache --virtual .build-deps g++ zlib-dev make python3-dev py3-numpy-dev jpeg-dev musl-dev lapack-dev libstdc++ \
    && pip install matplotlib \
    && pip install scikit-image \
    && python -c "import skimage" \
    && apk del .build-deps \
    && python -c "import skimage"

