FROM dahanna/python.3.7-git-tox-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

RUN apk --update add --no-cache --virtual g++

RUN pip install --no-cache-dir pandas
# --no-cache-dir reduced image size from 226.67MB to .

# RUN apk del g++
