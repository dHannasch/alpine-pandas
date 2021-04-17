FROM dahanna/python-ray:pre-bazel-alpine

RUN apk add --no-cache bazel3 --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN ls /usr/bin/bazel \
    && ls /usr/bin/bazel-real \
    && bazel-real --version \
    && echo "bazel-real --version succeeded!" \
    # https://github.com/bazelbuild/bazel/blob/master/scripts/packages/bazel.sh
    && (bazel --version || echo "bazel --version failed.")

