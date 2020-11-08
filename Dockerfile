FROM registry.access.redhat.com/ubi7/ubi:7.7

RUN subscription-manager repos --enable rhel-7-server-optional-rpms --enable rhel-server-rhscl-7-rpms \
    && yum --disableplugin=subscription-manager -y install rh-python38 \
    && scl enable rh-python36 bash \
    && yum --disableplugin=subscription-manager -y install nc nmap \
    && yum --disableplugin=subscription-manager clean all \
    && python --version
RUN yum --disableplugin=subscription-manager -y install rh-python38-python-tools \
    yum --disableplugin=subscription-manager -y install @development \
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
    && python -c "import ray"
