FROM dahanna/python-visualization:pillow-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

# RuntimeError: llvm-config failed executing, please point LLVM_CONFIG to the path for llvm-config
RUN apk --no-cache add --virtual llvm9-dev \
    && LLVM_CONFIG=/usr/lib/llvm9/bin/llvm-config python -m pip install --no-cache-dir datashader \
    && apk --no-cache del llvm9-dev
