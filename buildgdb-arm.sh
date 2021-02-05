apt-get install make texinfo
cd gdb-8.1.1
$./configure --target=arm-linux --prefix=/usr/local/arm-gdb -v
make -j4
make install
