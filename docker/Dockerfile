FROM ubuntu:20.04

# system basics
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install libpixman-1-dev curl build-essential debootstrap debian-archive-keyring libjpeg-dev zlib1g-dev unzip wget graphviz curl python2-dev git wget flex bison libtool automake autoconf autotools-dev pkg-config libglib2.0-dev \
# qemu deps
    pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev

RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && python2 get-pip.py

WORKDIR /qira

# install python deps, this step will be cached
COPY ./requirements.txt ./requirements.txt
RUN pip install --upgrade -r requirements.txt

#build qemu and link qira
COPY ./tracers ./tracers
RUN cd tracers && ./qemu_build.sh
RUN ln -sf /qira/middleware/qira.py /usr/local/bin/qira

COPY . .

# test will build Cython qiradb
RUN ./run_tests.sh
