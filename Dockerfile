FROM python:3.7-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# We need git to check whether all files are in version control.
# But in a CI build, all files are in version control by definition.
# So we could have a different tox task that skips that step,
# and instruct the CI to only run the non-git-using task.
# But installing git costs little, and this keeps things simpler.

RUN apk --update add --no-cache git

# Since one of the tox tests is to successfully build the documentation,
# we will definitely need sphinx.
RUN pip install --no-cache-dir tox sphinx
# Adding --no-cache-dir to pip reduced the image size from 49.22MB to 45.54MB.
