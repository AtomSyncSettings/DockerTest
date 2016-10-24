# Start with an Ubuntu 14.04 image
FROM ubuntu:14.04
MAINTAINER John Doe <jdoe@example.com>

#DNS update: This is neede inside Erasmus (but doesn't hurt in other envoriments)
RUN "sh" "-c" "echo nameserver 10.176.0.8 >> /etc/resolv.conf"

# Update the sources list
RUN apt-get update

# Install tools for building
RUN apt-get install -y -qq build-essential cmake
# Install extraction tools
RUN apt-get install -y -qq tar unzip
# Git needed later on
RUN apt-get install -y -qq git
# pip for python tools
RUN apt-get install -y -qq python-pip
RUN pip install flake8

# Everything will be placed in the /home/tools dir, first ITK:
WORKDIR /home/tools/ITK/

# Obtain the ITK sources
ADD http://downloads.sourceforge.net/project/itk/itk/4.10/InsightToolkit-4.10.1.tar.gz?r=https%3A%2F%2Fitk.org%2FITK%2Fresources%2Fsoftware.html&ts=1477129065&use_mirror=kent /home/tools/ITK/itk.tar.gz
RUN mkdir /home/tools/ITK/ITK-src/ && tar -xzf /home/tools/ITK/itk.tar.gz -C /home/tools/ITK/ITK-src/ --strip-components=1

# Compile ITK
WORKDIR /home/tools/ITK/ITK-bin/
RUN cmake -DModule_ITKReview=ON -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF /home/tools/ITK/ITK-src/
RUN make -j2

# Obtain Elastix
WORKDIR /home/Elastix
ADD https://github.com/mstaring/elastix/archive/master.zip elastix_sources.zip
RUN mkdir /home/Elastix/Elastix-src/ && unzip elastix_sources.zip -d /home/Elastix/Elastix-src/

# Build Elastix
WORKDIR /home/Elastix/Elastix-src/elastix-master/
RUN cmake -DCMAKE_BUILD_TYPE=Release -DITK_DIR=/home/tools/ITK/ITK-bin/ -DUSE_KNNGraphAlphaMutualInformationMetric=OFF
RUN make -j2 install
RUN elastix -help


WORKDIR /home/pytest/
ADD https://github.com/AtomSyncSettings/DockerTest/archive/master.zip master.zip
RUN unzip master.zip
WORKDIR /home/pytest/DockerTest-master/
RUN flake8 test.py


