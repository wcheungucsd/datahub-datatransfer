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


###
### Install extra file/data transfer apps
### REF: https://fasterdata.es.net/data-transfer-tools/
### REF: http://moo.nac.uci.edu/~hjm/HOWTO_move_data.html
### REF: https://education.sdsc.edu/training/interactive/?id=202406-Data-Transfer
###

### Install wget
RUN apt-get -y install wget

### Install curl
RUN apt-get -y install curl

### Install rsync
RUN apt-get -y install rsync

### Install ncftp
RUN apt-get -y install ncftp

### Install lftp
RUN apt-get -y install lftp

### Install axel
RUN apt-get -y install axel

### Install aria2
RUN apt-get -y install aria2

### Install RClone
RUN apt-get -y install rclone

### Install bbcp
RUN cd /usr/local/bin/. && curl -kJRLO https://www.slac.stanford.edu/~abh/bbcp/bin/amd64_ubuntu22.04/bbcp && chmod 755 ./bbcp && cd

### Install Cyberduck
RUN echo -e "deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main" | tee /etc/apt/sources.list.d/cyberduck.list > /dev/null && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FE7097963FEFBE72 && apt-get -y update && apt-get -y install duck

### Install aws-cli (for AWS S3)
#RUN snap install aws-cli --classic
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install


###
### Install extra file management apps
###

### Install tree
RUN apt-get -y install tree

### Install gdu
RUN apt-get -y install gdu

### Install ncdu
RUN apt-get -y install ncdu

### Install duc
RUN apt-get -y install duc



# 3) install packages using notebook user
USER jovyan

# RUN conda install -y scikit-learn

RUN pip install --no-cache-dir networkx scipy

# Override command to disable running jupyter notebook at launch
# CMD ["/bin/bash"]
