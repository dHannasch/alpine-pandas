FROM python:3.8-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

# We need git to pip install from git repositories.

RUN apk --update add --no-cache git \
    && pip install --upgrade --no-cache-dir pip
# Adding --no-cache-dir to pip reduced the image size from 49.22MB to 45.54MB.
