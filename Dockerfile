# 1) choose base container
# generally use the most recent tag

# base notebook, contains Jupyter and relevant tools
# See https://github.com/ucsd-ets/datahub-docker-stack/wiki/Stable-Tag 
# for a list of the most current containers we maintain
ARG BASE_CONTAINER=ghcr.io/ucsd-ets/datascience-notebook:stable

FROM $BASE_CONTAINER

#LABEL maintainer="UC San Diego ITS/ETS <ets-consult@ucsd.edu>"
LABEL maintainer="wcheung@ucsd.edu"

# 2) change to root to install packages
USER root

### Clean up and update APT
RUN apt-get -y clean && apt-get -y update && apt-get -y upgrade


###
### Install extra support apps
###

### Install mandoc man-db
RUN apt-get install -y mandoc man-db

### Install support for PPAs
RUN apt-get install -y software-properties-common



###
### Install extra file/data transfer apps
### REF: https://fasterdata.es.net/data-transfer-tools/
### REF: http://moo.nac.uci.edu/~hjm/HOWTO_move_data.html
### REF: https://education.sdsc.edu/training/interactive/?id=202406-Data-Transfer
###

### Install wget
### REF: https://www.gnu.org/software/wget/
RUN apt-get -y install wget

### Install curl
### REF: https://curl.se/
RUN apt-get -y install curl

### Install rsync
### REF: https://github.com/RsyncProject/rsync
RUN apt-get -y install rsync

### Install ncftp
### REF: https://www.ncftp.com/ncftp/
RUN apt-get -y install ncftp

### Install lftp
### REF: https://lftp.yar.ru/
RUN apt-get -y install lftp

### Install axel
### REF: https://github.com/axel-download-accelerator/axel
RUN apt-get -y install axel

### Install aria2
### REF: https://aria2.github.io/
RUN apt-get -y install aria2

### Install bbcp
### REF: https://www.slac.stanford.edu/~abh/bbcp/
RUN cd /usr/local/bin/. && curl -kJRLO "https://www.slac.stanford.edu/~abh/bbcp/bin/amd64_ubuntu22.04/bbcp" && chmod 755 ./bbcp && cd

### Install hpnssh
### REF: https://www.psc.edu/hpn-ssh-home/
RUN add-apt-repository -y ppa:rapier1/hpnssh && apt-get -y update && apt-get -y install hpnssh

### Install fdt
### REF: https://fast-data-transfer.github.io/
RUN apt-get install -y default-jre
RUN cd /usr/local/bin/. && curl -JRLO "https://github.com/fast-data-transfer/fdt/releases/download/0.27.0/fdt.jar" && chmod 644 ./fdt.jar && cd

### Install Globus Connect Personal (GCP)
### REF: https://www.globus.org/globus-connect-personal
RUN cd /tmp/. && curl -JRLO "https://downloads.globus.org/globus-connect-personal/linux/stable/globusconnectpersonal-latest.tgz" && cd /usr/local/bin/. && tar xvzf /tmp/globusconnectpersonal-latest.tgz && cd /usr/local/bin/. && ln -sf /usr/local/globusconnectpersonal-*/globusconnectpersonal . && cd


### Install rclone (for multi-cloud)
### REF: https://rclone.org/
RUN apt-get -y install rclone

### Install cyberduck (for multi-cloud)
### REF: https://duck.sh/
RUN echo -e "deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main" | tee /etc/apt/sources.list.d/cyberduck.list > /dev/null && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FE7097963FEFBE72 && apt-get -y update && apt-get -y install duck

### Install awscli (for AWS S3)
### REF: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
#RUN snap install aws-cli --classic
RUN cd /tmp/. && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install & cd

### Install gcloud (for Google Drive)
### REF: https://cloud.google.com/sdk/docs/install#deb
#RUN snap install google-cloud-cli --classic
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-cli -y

### Install gdrive (for Google Drive)
### REF: https://github.com/glotlabs/gdrive
RUN cd /tmp/. && curl -JRLO "https://github.com/glotlabs/gdrive/releases/download/3.9.1/gdrive_linux-x64.tar.gz" && cd /usr/local/bin/. && tar xvzf /tmp/gdrive_linux-x64.tar.gz && chmod 755 ./gdrive && cd

### Install google-drive-ocamlfuse (for Google Drive)
### REF: https://github.com/astrada/google-drive-ocamlfuse
RUN add-apt-repository -y ppa:alessandro-strada/ppa && apt-get -y update && apt-get -y install google-drive-ocamlfuse

### Install azcopy (for Azure cloud)
### REF: https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10
RUN cd /tmp/. && curl -sSL -O https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb && apt-get -y update && apt-get -y install azcopy && cd

### Install OneDrive
### REF: https://github.com/abraunegg/onedrive/blob/master/docs/install.md
RUN cd /tmp/. && wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/ ./" | tee /etc/apt/sources.list.d/onedrive.list && apt-get -y update && apt-get -y install --no-install-recommends --no-install-suggests onedrive && cd

### Install Dropbox
### REF: https://help.dropbox.com/installs/linux-commands
RUN cd /tmp/. && curl -JRLO "https://linux.dropboxstatic.com/packages/ubuntu/dropbox_2024.04.17_amd64.deb" && dpkg -i dropbox_2024.04.17_amd64.deb && apt-get -y update && apt-get -y install dropbox && cd 



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
