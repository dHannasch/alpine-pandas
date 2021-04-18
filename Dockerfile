FROM dahanna/python-ray:ray-dashboard-alpine

RUN cd ray/python \
    && pip install --editable . --verbose
# RUN python -m pip install --no-cache-dir ray[debug] --verbose
