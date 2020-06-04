FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime

RUN apt-get update && apt-get install --assume-yes wget
RUN python -m pip install detectron2 -f \
  https://dl.fbaipublicfiles.com/detectron2/wheels/cu101/torch1.5/index.html
RUN python -m pip install cython
RUN apt-get install --assume-yes gcc
# detectron2 requires a newer version of pycocotools
RUN python -m pip install git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI