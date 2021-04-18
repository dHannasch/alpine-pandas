FROM dahanna/python-ray:ray-dashboard-alpine

RUN pip install --no-build-isolation numpy aiohttp multidict yarl gpustat nvidia-ml-py3 hiredis pyrsistent psutil pyyaml

