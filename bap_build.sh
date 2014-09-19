#!/bin/bash -e

# this script is woefully incomplete
# because I already had tons of stuff on this VM
# update before release

sudo apt-get install ocaml-interp libpqxx-3.1 libpqxx3-dev glogg python-dev postgresql-server-dev-9.3 g++-4.8 gcc-4.8 ocaml-findlib opam camlp4-extra cmake
opam init
opam install piqi zarith core_kernel

mkdir -p bap
cd bap

if [ ! -d capnproto ]; then
  pushd .
  git clone https://github.com/kentonv/capnproto.git
  cd capnproto/c++
  ./setup-autotools.sh
  autoreconf -i && ./configure && make -j6 check && sudo make install
  popd
fi

sudo pip install -U cython
sudo pip install pycapnp

if [ ! -d bap-types ]; then
  pushd .
  git clone https://github.com/BinaryAnalysisPlatform/bap-types.git

  cd bap-types
  ./configure
  make -j $(grep processor < /proc/cpuinfo | wc -l)
  make install

  popd
fi

if [ ! -d llvm ]; then
  pushd .
  git clone https://github.com/maurer/llvm.git
  cd llvm
  git checkout c-disasm-mcinst
  popd
fi

if [ ! -d llvm-build ]; then
  pushd .
  mkdir llvm-build
  cd llvm-build
  ../llvm/configure --enable-optimized
  make -j $(grep processor < /proc/cpuinfo | wc -l)

  # clobber the system llvm
  sudo make install
  popd
fi

if [ ! -d llvm-mc ]; then
  pushd .
  git clone https://github.com/BinaryAnalysisPlatform/llvm-mc.git
  cd llvm-mc

  ./configure
  make -j $(grep processor < /proc/cpuinfo | wc -l)
  make install
  popd
fi

if [ ! -d bap-lifter ]; then
  pushd .
  git clone https://github.com/BinaryAnalysisPlatform/bap-lifter.git

  cd bap-lifter
  ./configure
  make -j $(grep processor < /proc/cpuinfo | wc -l)
  make install

  popd
fi


if [ ! -d holmes ]; then
  pushd .
  git clone https://github.com/BinaryAnalysisPlatform/holmes.git

  cd holmes
  mkdir build && cd build
  cmake -DCMAKE_CXX_COMPILER=g++-4.8 ..
  make

  popd
fi

# installed at bap/bap-lifter/toil.native

