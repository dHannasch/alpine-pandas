FROM dahanna/python-ray:ray-deps-alpine

RUN cd ray/python \
    && pip install --no-build-isolation --editable . --verbose
# RUN python -m pip install --no-cache-dir ray[debug] --verbose
