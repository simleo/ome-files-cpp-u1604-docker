FROM ubuntu:16.04
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN apt-get update && apt-get -y install \
  build-essential \
  cmake \
  git \
  man \
  libboost-all-dev \
  libxerces-c-dev \
  libxalan-c-dev \
  libpng-dev \
  libgtest-dev \
  libtiff5-dev \
  python-pip
RUN pip install --upgrade pip
RUN pip install Genshi
RUN pip install Sphinx

WORKDIR /git
RUN git clone --branch='v0.3.2' https://github.com/ome/ome-cmake-superbuild.git

WORKDIR /build
RUN cmake \
    -DCMAKE_CXX_STANDARD=11 \
    -Dgit-dir=/git \
    -Dbuild-prerequisites=OFF \
    -Dome-superbuild_BUILD_gtest=ON \
    -Dbuild-packages=ome-files \
    -DCMAKE_BUILD_TYPE=Release \
    /git/ome-cmake-superbuild
RUN make
RUN make install
RUN ldconfig
