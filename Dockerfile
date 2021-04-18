FROM dahanna/python-ray:npm-alpine

RUN cd ray/dashboard/client \
    && npm install \
    && npm run build \
    && cd ../../..

