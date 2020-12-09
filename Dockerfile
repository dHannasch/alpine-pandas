FROM dahanna/python-alpine-package:tox-alpine

# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# Right now this is an omnibus image that includes everything,
# but once we identify the best way of doing Samba we'll reduce this down.

RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev krb5-dev openssl-dev \
    && pip install smbprotocol[kerberos] \
    && apk del --no-cache .build-deps gcc musl-dev libffi-dev krb5-dev openssl-dev \
    && python -c "import smbprotocol"

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

