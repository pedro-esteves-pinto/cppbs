FROM ubuntu:hirsute

RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common

# other build tools
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
build-essential \
git \
gdb \
cmake \
python \
ccache \
ninja-build \
pip

# newer GCC
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gcc-11 g++-11
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 60 --slave /usr/bin/g++ g++ /usr/bin/g++-11

# CLANG
run \
git clone https://github.com/llvm/llvm-project.git && \
cd llvm-project && \
git checkout release/13.x && \
cmake -S llvm -B build -G Ninja \
-DCMAKE_BUILD_TYPE=Release \
-DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;poly;cross-project-tests' \
-DCMAKE_INSTALL_PREFIX=/usr/local && \
cmake --build build -t install && \
rm -rf /llvm-project && \
ln -s /usr/local/bin/clang /usr/bin/clang && \
ln -s /usr/local/bin/clang++ /usr/bin/clang++ 

# install conan
RUN \
pip install conan paramiko

RUN apt-get clean

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

