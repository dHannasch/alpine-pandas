FROM tensorflow/tensorflow:1.15.0-gpu-py3-jupyter

# We need git to check whether all files are in version control.
# But in a CI build, all files are in version control by definition.
# So we could have a different tox task that skips that step,
# and instruct the CI to only run the non-git-using task.
# But installing git costs little, and this keeps things simpler.

RUN apt-get update && apt-get install --assume-yes git
RUN apt-get install --assume-yes libavformat-dev libavfilter-dev libavdevice-dev ffmpeg

# Since one of the tox tests is to successfully build the documentation,
# we will definitely need sphinx.
RUN pip uninstall --no-cache-dir --yes enum34
RUN pip install --no-cache-dir tox sphinx
