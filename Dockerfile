FROM python:3.7-alpine

RUN apk --update add --no-cache git

RUN pip install tox
