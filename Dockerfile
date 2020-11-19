FROM dahanna/ubuntu:wget

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends python3-dev python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    # When debugging Ray, we'll want to check whether we can reach the host and port from the container.
    && apt-get install --assume-yes --no-install-recommends netcat nmap \
    && apt-get install --assume-yes --no-install-recommends openssh-client \
    # Warning: this will enable incoming SSH connections by default.
    # Is there a good way to make this easy to turn on and off?
    && apt-get install --assume-yes --no-install-recommends openssh-server \
    # Turns out it doesn't seem to matter because you can't make incoming ssh connections anyway,
    # maybe gitlab-runner is blocking it...?
    && apt-get install --assume-yes --no-install-recommends iptables \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
    && apt-get install gcc \
    && python -m pip install --no-cache-dir psutil \
    && apt-get purge --assume-yes gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN python -m pip install --no-cache-dir https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-1.1.0.dev0-cp38-cp38-manylinux2014_x86_64.whl
RUN apt-get update \
    && apt-get install --assume-yes build-essential \
    # The instructions at https://docs.ray.io/en/master/installation.html
    # say to get the latest snapshot with ray install-nightly followed by pip install ray[<library>].
    # However, if you follow those instructions, ray install-nightly will crash.
    # ERROR: HTTP error 404 while getting https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-1.0.0-cp38-cp38-manylinux1_x86_64.whl
    #  File "/usr/lib/python3.8/subprocess.py", line 364, in check_call
    #  raise CalledProcessError(retcode, cmd)
    # subprocess.CalledProcessError: Command '['/usr/bin/python', '-m', 'pip', 'install', '-U', 'https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-1.0.0-cp38-cp38-manylinux1_x86_64.whl']' returned non-zero exit status 1.
    # It appears maybe ray install-nightly will not upgrade to Ray 1.1? And the wheel for Ray 1.0 is long gone?
    # && python -m pip install --no-cache-dir ray[debug] \
    # && echo "done pip install ray[debug], about to ray install-nightly" \
    # && ray install-nightly \
    # && echo "done ray install-nightly, about to pip install ray[debug]" \
    # && python -m pip install --no-cache-dir ray[debug] \
    && python -m pip install --no-cache-dir https://s3-us-west-2.amazonaws.com/ray-wheels/latest/ray-1.1.0.dev0-cp38-cp38-manylinux2014_x86_64.whl \
    # This is not ideal, because this is hardcoded to a particular version number, so to upgrade can't just re-build, must edit the Dockerfile.
    && apt-get purge --assume-yes build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python -c "import ray"
