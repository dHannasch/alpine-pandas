FROM dahanna/python-alpine-package:alpine-python3-dev-git
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

RUN apk add --no-cache openssh-client
RUN python -m pip install --no-cache-dir git+https://github.com/dHannasch/cookiecutter.git@f0b1b5e91adee3f2f37d3c88458a20ade82c1605 \
    && python -m pip install --no-cache-dir git+https://github.com/dHannasch/python-cookiepatcher.git@allow-tab-complete-target-directory-name

