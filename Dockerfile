FROM python:3.8-slim

RUN python -m pip install --no-cache-dir ray[debug] --verbose
