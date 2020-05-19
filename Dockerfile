FROM dahanna/python:3.6-tensorflow-1.15-ffmpeg-pandoc
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

RUN pip install --no-cache-dir ipykernel \
    && python -m ipykernel install \
    && pip install --no-cache-dir ipywidgets \
    && pip install --no-cache-dir plotly

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

