FROM dahanna/python-ray:bazel-alpine

RUN git clone https://github.com/benfred/py-spy.git \
    && cd py-spy \
    && pip install --editable . --verbose \
    && cd ..

