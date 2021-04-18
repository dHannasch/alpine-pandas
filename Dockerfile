FROM dahanna/python-ray:install-bazel-sh-alpine

RUN cd ray/dashboard/client \
    && npm install \
    && npm run build \
    && cd ../../..

