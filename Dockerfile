FROM pytorch/pytorch:1.5-cuda10.1-cudnn7-runtime

RUN python -m pip install detectron2 -f \
  https://dl.fbaipublicfiles.com/detectron2/wheels/cu101/torch1.5/index.html