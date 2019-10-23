FROM dahanna/python:3.7-scipy-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

RUN apk --update add --no-cache --virtual build-base freetype-dev pkgconfig g++ \
    && pip install --no-cache-dir seaborn \
    && python -c "import seaborn" \
    && apk del --no-cache build-base freetype-dev pkgconfig g++ \
    # apk del reduced image size from 365MB to .
    && apk add --no-cache freetype
    # freetype is needed to import matplotlib. Without it, we get this error:
#     import matplotlib.pyplot as plt
#  File "/usr/local/lib/python3.7/site-packages/matplotlib/__init__.py", line 205, in <module>
#    _check_versions()
#  File "/usr/local/lib/python3.7/site-packages/matplotlib/__init__.py", line 190, in _check_versions
#    from . import ft2font
# ImportError: Error loading shared library libfreetype.so.6: No such file or directory (needed by /usr/local/lib/python3.7/site-packages/matplotlib/ft2font.cpython-37m-x86_64-linux-gnu.so)

