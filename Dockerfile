FROM dahanna/python-ray:install-bazel-sh-alpine

RUN pushd ray/dashboard/client \
    && npm install \
    && npm run build \
    && popd

