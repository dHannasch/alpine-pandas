FROM pythonpackagesonalpine/basic-python-packages-pre-installed-on-alpine:pip-alpine

RUN pip install --no-cache-dir scikit-build \
    python -c "import skbuild"

