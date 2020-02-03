FROM tensorflow/tensorflow:1.15.0-py3

# We need git to check whether all files are in version control.
# But in a CI build, all files are in version control by definition.
# So we could have a different tox task that skips that step,
# and instruct the CI to only run the non-git-using task.
# But installing git costs little, and this keeps things simpler.

RUN apt-get install git
RUN apt-get install libavformat-dev libavfilter-dev libavdevice-dev ffmpeg

# Since one of the tox tests is to successfully build the documentation,
# we will definitely need sphinx.
RUN pip install --no-cache-dir tox sphinx
