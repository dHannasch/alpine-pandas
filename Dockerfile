FROM dahanna/python:3.7-paramiko-alpine
# Since this image is intended for continuous integration, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.7-alpine is 32.27MB.

# An apk del in an extra layer has no benefit.
# Removing files makes images larger, not smaller.
# You must apk add and apk del in the same layer to benefit from it.

  # https://github.com/openagua/alpine-glpk-python3
  # https://hub.docker.com/r/frolvlad/alpine-python-machinelearning/dockerfile
RUN apk add --no-cache --virtual llvm-dev \
    && apk add suitesparse-dev --repository=http://nl.alpinelinux.org/alpine/edge/main \
    && wget "ftp://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz" \
    && tar xzf "glpk-4.65.tar.gz" \
    && cd "glpk-4.65" \
    && ./configure --disable-static \
    && make \
    && make install-strip \
    && cd .. \
    && CVXOPT_BLAS_LIB=openblas CVXOPT_LAPACK_LIB=openblas CVXOPT_BLAS_LIB_DIR=/usr/include/suitesparse CVXOPT_SUITESPARSE_INC_DIR=/usr/include/suitesparse CVXOPT_BUILD_GLPK=1 pip install --no-cache-dir cvxopt \
    && python -c "import cvxopt" \
    && apk del --no-cache llvm-dev \
    && python -c "import cvxopt"
    # apk del reduced image size from 365MB to .

