apt-get install -y gcc make build-essential bison flex libgmp3-dev libmpc-dev 	libmpfr-dev texinfo libisl-dev clang *zlib zlib*
apt-get install build-essential zlib1g-dev pkg-config libglib2.0-dev binutils-dev libboost-all-dev autoconf libtool libssl-dev libpixman-1-dev libpython-dev python-pip python-capstone virtualenv -y
apt-get install libsdl1.2-dev -y
apt-get install libpixman-1-dev

cd ./qemu-2.11.0
./configure --target-list=aarch64-softmmu --enable-modules --enable-tcg-interpreter --enable-debug-tcg --python=/usr/bin/python2.7
make -j4
sudo make install
qemu-system-aarch64 -version
