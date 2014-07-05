#!/bin/bash
set -e

if [ ! -d qemu/qemu-latest ]; then
  rm -rf qemu
  mkdir -p qemu
  cd qemu
  wget http://wiki.qemu-project.org/download/qemu-2.1.0-rc0.tar.bz2
  tar xf qemu-2.1.0-rc0.tar.bz2
  ln -s qemu-2.1.0-rc0 qemu-latest
  cd qemu-latest
  mv tci.c tci.c.bak
  mv linux-user/qemu.h linux-user/qemu.h.bak
  cd ../../
fi

cd qemu/qemu-latest
ln -sf ../../qemu_mods/tci.c tci.c
ln -sf ../../../qemu_mods/qemu.h linux-user/qemu.h
./configure --target-list=i386-linux-user,arm-linux-user,x86_64-linux-user --enable-tcg-interpreter --enable-debug-tcg --cpu=unknown
make -j32

