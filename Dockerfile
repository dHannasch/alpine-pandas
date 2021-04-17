FROM dahanna/python-ray:grpcio-alpine

RUN git clone https://github.com/ray-project/ray.git \
    # && ray/ci/travis/install-bazel.sh
    # yields
    # The Bazel installer must have write access to /root/bin! Consider using the --user flag to install Bazel under /root/bin instead.
    # https://github.com/ray-project/ray/blob/master/ci/travis/install-bazel.sh#L58
    # I think what's going wrong is that install-bazel.sh is trying to install with --user which tries to install under /root/bin instead of /usr/bin.
    # && ray/ci/travis/install-bazel.sh --system
    # yields
    # The Bazel installer must have write access to /usr/local/bin!
    # Consider using the --user flag to install Bazel under /root/bin instead.
    && bazel --help

