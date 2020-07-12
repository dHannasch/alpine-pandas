FROM dahanna/python-visualization:pillow-alpine
# Since this image is intended for continuous integration, and for saving
# multiple Docker images on a GitLab registry, we want to
# keep the size down, hence Alpine.
# Some packages might have tests that take much longer than it could ever
# take to download even a large Docker image, but we want this image to
# be applicable to all packages including small packages.
# python:3.8-alpine is 24.98MB.

# RuntimeError: llvm-config failed executing, please point LLVM_CONFIG to the path for llvm-config
# Even with llvm9-dev installed, /usr/lib/llvm9/bin/llvm-config is not appearing, even though it should
# according to https://pkgs.alpinelinux.org/contents?branch=edge&name=llvm9-dev&arch=x86_64&repo=main
# as should /usr/bin/llvm9-config . Also apk adding build-base makes it appear.
RUN apk --no-cache add --virtual build-base make g++ musl-dev llvm9-dev py3-numpy-dev \
    && apk --no-cache add --virtual libtbb-dev --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    && find / -name *llvm* \
    && LLVM_CONFIG=/usr/lib/llvm9/bin/llvm-config pip install --no-cache-dir git+https://github.com/stuartarchibald/numba.git@fix/cuda_atomic_nanminmax \
    && python -c "import numba" \
    && apk del --no-cache        build-base make g++ musl-dev llvm9-dev libtbb-dev py3-numpy-dev \
    # OSError: Could not load shared object file: libllvmlite.so
    && apk --no-cache add llvm9 \
    && python -c "import numba"
RUN apk --no-cache add --virtual build-base llvm9-dev \
    && find / -name *llvm* \
    && ls /usr/lib/llvm9/bin/llvm-config \
    && LLVM_CONFIG=/usr/lib/llvm9/bin/llvm-config python -m pip install --no-cache-dir git+https://github.com/dHannasch/datashader.git@fix/numba_cuda_atomic_minmax_test_with_branch \
    && apk --no-cache del build-base llvm9-dev \
    && python -c "import datashader"
