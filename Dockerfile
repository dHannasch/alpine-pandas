FROM frolvlad/alpine-miniconda3
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

RUN conda create --name test-env sphinx conda-build
# Since one of the tox tests is to successfully build the documentation,
# we will definitely need sphinx.
# If we're using conda, we presumably intend to build a conda package.
RUN conda install --name test-env --channel conda-forge tox pytest
# RUN conda init bash
# RUN source /root/.bashrc
# RUN conda activate test-env \
RUN source activate test-env \
    && python -c "import sys; print(sys.executable)"
