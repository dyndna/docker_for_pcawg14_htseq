############################################################
# Dockerfile to build docker image: dyndna/pcawg14_htseq:0.9.2
# https://registry.hub.docker.com/u/dyndna/pcawg14_htseq/tags/manage/
	# Based on docker image: genomicpariscentre/htseq:0.6.1p1
	# Credits: Laurent Jourdren <jourdren@biologie.ens.fr>, Genomic Paris Centre
	# Source: https://registry.hub.docker.com/u/genomicpariscentre/htseq/dockerfile/
############################################################

# Set the base image to Ubuntu
FROM ubuntu:12.04

# File Author / Maintainer
MAINTAINER Samir B. Amin <@sbamin>

# Update the repository sources list
# If you encounter DNS error, see https://gist.github.com/dyndna/12b2317b5fbade37e747
RUN apt-get update

# Install dependencies
RUN apt-get install --yes build-essential python2.7-dev python-numpy python-matplotlib gdebi git wget curl libncurses5-dev libncursesw5-dev tar zip unzip

# Create non-root user, foo
RUN useradd -m -d /home/foo -s /bin/bash -c "Dummy User"  -U foo && id -a foo

# Download and uncompress HTSeq archive
ADD htseq/HTSeq-0.6.1p2.tar.gz /tmp/

# Install HTSeq
RUN cd /tmp/* && python setup.py build && python setup.py install

# Install samtools
RUN mkdir -p /opt/samtools && cd /opt/samtools && wget --no-check-certificate https://github.com/samtools/samtools/releases/download/1.2/samtools-1.2.tar.bz2 && tar xvjf samtools-1.2.tar.bz2 && cd /opt/samtools/samtools-1.2 && make && make prefix=/opt/samtools/v1.2 install && cd .. && rm -rf samtools-1.2 && ln -s v1.2 default

# Install genetorrent
RUN mkdir -p /opt/genetorrent && cd /opt/genetorrent && wget --no-check-certificate https://cghub.ucsc.edu/software/downloads/GeneTorrent/3.8.7/genetorrent-common_3.8.7-ubuntu2.207-12.04_amd64.deb && wget --no-check-certificate https://cghub.ucsc.edu/software/downloads/GeneTorrent/3.8.7/genetorrent-download_3.8.7-ubuntu2.207-12.04_amd64.deb && gdebi -n genetorrent-common_3.8.7-ubuntu2.207-12.04_amd64.deb && gdebi -n genetorrent-download_3.8.7-ubuntu2.207-12.04_amd64.deb && which gtdownload && which cgquery

# Add samtools to PATH
RUN ln -s /opt/samtools/default/bin/* /usr/local/bin/

# Configure /etc/profile
RUN cd /etc && cp profile profile.orig.bk && mkdir -p /etc/profile.d
ADD profile/profile /etc/
ADD profile/ngstools.sh /etc/profile.d/

# Cleanup
RUN apt-get clean
RUN rm -rf /tmp/*

###### END #######

