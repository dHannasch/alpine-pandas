FROM dahanna/python-visualization:datashader-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

# /usr/lib/gcc/x86_64-alpine-linux-musl/9.3.0/include/stdint.h:9:26: error: no include path in which to search for stdint.h
# musl-dev fixed that
# gcc: fatal error: cannot execute 'cc1plus': execvp: No such file or directory
# maybe...g++?
RUN apk --no-cache add --virtual build-base g++ musl-dev \
    && python -m pip install --no-cache-dir dash dash-bootstrap-components \
    && apk --no-cache del build-base g++ musl-dev \
    && python -c "import dash" \
    && python -c "import dash_bootstrap_components"
