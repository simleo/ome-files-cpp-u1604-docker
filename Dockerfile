FROM ubuntu:17.04
MAINTAINER ome-devel@lists.openmicroscopy.org.uk

RUN apt-get update && apt-get -y install \
  build-essential \
  curl \
  git \
  man \
  libboost-all-dev \
  libxerces-c-dev \
  libxalan-c-dev \
  libpng-dev \
  libgtest-dev \
  libtiff5-dev \
  locales \
  python-pip \
  doxygen \
  doxygen-gui \
  graphviz \
  && locale-gen en_US.UTF-8

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN curl -O https://cmake.org/files/v3.9/cmake-3.9.0-rc5.tar.gz
RUN tar xf cmake-3.9.0-rc5.tar.gz
WORKDIR /cmake-3.9.0-rc5
RUN ./bootstrap && make && make install

RUN pip install --upgrade pip
RUN pip install Genshi
RUN pip install Sphinx

WORKDIR /git
RUN git clone --branch='v5.4.1' https://github.com/ome/ome-common-cpp.git
RUN git clone --branch='v5.5.3' https://github.com/ome/ome-model.git
RUN git clone --branch='master' https://github.com/ome/ome-files-cpp.git
RUN git clone --branch='v5.4.1' https://github.com/ome/ome-qtwidgets.git
RUN git clone --branch='v0.3.2' https://github.com/ome/ome-cmake-superbuild.git

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
