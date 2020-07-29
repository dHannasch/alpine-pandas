FROM dahanna/python-visualization:dash-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

RUN apk --no-cache add --virtual build-base g++ musl-dev py3-numpy-dev \
    && pip install statsmodels \
    && python -c "import statsmodels"

