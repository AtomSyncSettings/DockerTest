# Start with an Ubuntu 14.04 image
FROM ubuntu:14.04
MAINTAINER John Doe <jdoe@example.com>

#DNS update: This is neede inside Erasmus
RUN "sh" "-c" "echo nameserver 10.176.0.8 >> /etc/resolv.conf"

# Update the sources list
RUN apt-get update

# Install tools for building
RUN apt-get install -y build-essential cmake
# Install extraction tools
RUN apt-get install -y tar unzip
# Git needed later on
RUN apt-get install -y git

# Obtain the ITK sources
ADD http://downloads.sourceforge.net/project/itk/itk/4.8/InsightToolkit-4.8.2.tar.gz?r=&ts=1477036965&use_mirror=vorboss /itk.tar.gz
RUN mkdir /ITK-src/ && tar -xvzf itk.tar.gz -C /ITK-src/ --strip-components=1

# Compile ITK
WORKDIR /home/ITK/
RUN cmake -DBUILD_SHARED_LIBS=ON -DModule_ITKReview=ON -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF /ITK-src/
RUN make -j6

# Obtain Elastix
WORKDIR /home/Elastix
ADD https://github.com/mstaring/elastix/archive/master.zip elastix_sources.zip
RUN mkdir /Elastix-src/ && unzip elastix_sources.zip -d /Elastix-src/

# Build Elastix
RUN cmake -DCMAKE_BUILD_TYPE=Release -DITK_DIR=/home/ITK/ /Elastix-src/elastix-master/
RUN make -j6 install
RUN /home/Elastix/elastix -help


RUN git clone https://github.com/AtomSyncSettings/DockerTest.git
RUN pip install flake8
RUN flake8 test.py


