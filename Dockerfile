FROM dahanna/python-alpine-package:tox-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

# https://github.com/maddiefletcher/graphviz-docker/issues/1
# Since there's not really any fonts installed, the text just ends up being a string of boxes.
# SVG output works since it doesn't require the in-container graphviz install to have access to fonts.
# font-bitstream-type1 and ghostscript-fonts
RUN apk add --no-cache graphviz font-bitstream-type1 ghostscript-fonts

