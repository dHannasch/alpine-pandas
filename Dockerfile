FROM dahanna/python:3.7-seaborn-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

RUN apk add --no-cache openjdk11 fontconfig ttf-dejavu
# fontconfig and ttf-dejavu are necessary to prevent java.lang.NullPointerException
# at java.desktop/sun.awt.FontConfiguration.getVersion(FontConfiguration.java:1262)
RUN pip install --no-cache-dir git+https://github.com/dHannasch/py4j-compiling-java-on-the-fly.git@master

