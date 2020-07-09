FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime

RUN apt-get update && apt-get install --assume-yes wget
RUN python -m pip install --upgrade pip
# detectron2 requires a newer version of pycocotools
# pycocotools requires cython
RUN python -m pip install cython \
    && apt-get install --assume-yes gcc \
    && apt-get update && apt-get install --assume-yes git \
    && python -m pip install git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI
# pip install pycocotools fails with unable to execute 'gcc': No such file or directory
RUN python -m pip install detectron2 -f \
  https://dl.fbaipublicfiles.com/detectron2/wheels/cu101/torch1.5/index.html
# https://detectron2.readthedocs.io/tutorials/install.html
# from detectron2.utils.visualizer import Visualizer fails if you don't have cv2 importable
RUN conda install --channel menpo opencv
