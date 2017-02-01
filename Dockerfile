FROM ubuntu:16.04
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN apt-get update && apt-get -y install \
  build-essential \
  cmake \
  git \
  libboost-all-dev \
  libxerces-c-dev \
  libxalan-c-dev \
  libpng-dev \
  libgtest-dev \
  libtiff5-dev \
  python-pip
RUN pip install Genshi

WORKDIR /git
RUN git clone --branch='v0.2.3' https://github.com/ome/ome-cmake-superbuild.git

WORKDIR /build
RUN cmake \
    -Dgit-dir=/git \
    -Dbuild-prerequisites=OFF \
    -Dome-superbuild_BUILD_gtest=ON \
    -Dbuild-packages=ome-files \
    -DCMAKE_BUILD_TYPE=Release \
    /git/ome-cmake-superbuild
RUN make
RUN make install
RUN ldconfig

