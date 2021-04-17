FROM dahanna/python-ray:grpcio-alpine

RUN bazel-real --version \
    && (bazel --version || echo "bazel --version failed.") \
    && git clone https://github.com/dHannasch/ray.git --branch if-bazel-installed-only-configure \
    && ray/ci/travis/install-bazel.sh --system
    # && ray/ci/travis/install-bazel.sh
    # yields
    # The Bazel installer must have write access to /root/bin! Consider using the --user flag to install Bazel under /root/bin instead.
    # https://github.com/ray-project/ray/blob/master/ci/travis/install-bazel.sh#L58
    # I think what's going wrong is that install-bazel.sh is trying to install with --user which tries to install under /root/bin instead of /usr/bin.
    # && ray/ci/travis/install-bazel.sh --system
    # yields
    # The Bazel installer must have write access to /usr/local/bin!
    # Consider using the --user flag to install Bazel under /root/bin instead.
    # try just altering install-bazel.sh to check for bazel already found

