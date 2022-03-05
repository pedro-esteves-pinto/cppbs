FROM ubuntu:impish

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
build-essential \
software-properties-common \
git \
gdb \
cmake \
python \
ccache \
ninja-build \
pkg-config \
gcc \
clang \
clang-tidy \
clangd \
pip

# Conan
RUN pip install conan paramiko

RUN apt-get clean

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

