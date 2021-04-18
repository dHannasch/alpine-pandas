FROM dahanna/python-ray:ray-yaml-alpine

RUN pip install --no-build-isolation pyasn1 rsa pyasn1-modules protobuf multidict cachetools yarl typing-extensions googleapis-common-protos google-auth async-timeout pyrsistent psutil opencensus-context nvidia-ml-py3 hiredis google-api-core blessings aiohttp redis pyyaml prometheus-client opencensus numpy jsonschema gpustat click aioredis aiohttp-cors

