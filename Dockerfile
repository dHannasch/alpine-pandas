FROM pythonpackagesonalpine/python-visualization-alpine:matplotlib-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

RUN apk add --no-cache py3-scipy \
    && apk add --no-cache tesseract-ocr imagemagick \
    && apk add --no-cache --virtual .build-deps g++ make python3-dev py3-numpy-dev lapack-dev blas-dev zlib-dev jpeg-dev musl-dev \
    && pip install scikit-image \
    && python -c "import skimage" \
    && apk del --no-cache .build-deps \
    && apk add --no-cache py3-numpy \
    && python -c "import skimage"

