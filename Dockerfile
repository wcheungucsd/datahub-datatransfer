# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:stable

FROM $BASE_CONTAINER

LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"
LABEL maintainer="wcheung@ucsd.edu"

# 2) change to root to install packages
USER root

### Clean up and update APT
RUN apt-get -y clean && apt-get -y update && apt-get -y upgrade


### Install RClone
RUN apt-get -y install rclone

### Install aria2
RUN apt-get -y install aria2

### Install ncftp
RUN apt-get -y install ncftp

### Install Cyberduck
RUN echo -e "deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main" | tee /etc/apt/sources.list.d/cyberduck.list > /dev/null && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FE7097963FEFBE72 && apt-get -y update && apt-get -y install duck


# 3) install packages using notebook user
USER jovyan

# RUN conda install -y scikit-learn

RUN pip install --no-cache-dir networkx scipy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
