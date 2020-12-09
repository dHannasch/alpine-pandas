FROM dahanna/python-alpine-package:tox-alpine

# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# Right now this is an omnibus image that includes everything,
# but once we identify the best way of doing Samba we'll reduce this down.

RUN apk add --no-cache py-cryptography \
    && pip install --no-cache-dir pyspnego decorator \
    && pip install --no-cache-dir wheel \
    && apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev krb5-dev \
    && pip install --no-cache-dir gssapi \
    && pip install --no-cache-dir smbprotocol[kerberos] \
    && apk del --no-cache .build-deps \
    && python -c "import smbprotocol" \
    && python -c "import smbclient; smbclient.ClientConfig; smbclient.register_session" \
    && apk add --no-cache krb5

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

