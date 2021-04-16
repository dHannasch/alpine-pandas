FROM dahanna/python-ray:py-spy-alpine

RUN apk add --no-cache grpc \
    && pip install grpcio

