apt-get install -y gcc make build-essential bison flex libgmp3-dev libmpc-dev 	libmpfr-dev texinfo libisl-dev clang *zlib zlib* nasm
apt-get install -y gdb-multiarch
#clang --target=aarch64-elf

wget https://ftpmirror.gnu.org/binutils/binutils-2.30.tar.gz
wget https://ftpmirror.gnu.org/gcc/gcc-8.1.0/gcc-8.1.0.tar.gz
wget https://ftpmirror.gnu.org/mpfr/mpfr-4.0.1.tar.gz
wget https://ftpmirror.gnu.org/gmp/gmp-6.1.2.tar.bz2
wget https://ftpmirror.gnu.org/mpc/mpc-1.1.0.tar.gz
wget https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.18.tar.bz2
wget https://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz

for i in *.tar.gz; do tar -xzf $i; done
for i in *.tar.bz2; do tar -xjf $i; done
rm -f *.tar.*

cd binutils-*
ln -s ../isl-* isl
cd ..
cd gcc-*
ln -s ../isl-* isl
ln -s ../mpfr-* mpfr
ln -s ../gmp-* gmp
ln -s ../mpc-* mpc
ln -s ../cloog-* cloog
cd ..

mkdir aarch64-binutils
cd aarch64-binutils

../binutils-*/configure --prefix=/usr/local/cross-compiler --target=aarch64-elf --enable-shared --enable-threads=posix --enable-libmpx --with-system-zlib --with-isl --enable-__cxa_atexit --disable-libunwind-exceptions --enable-clocale=gnu --disable-libstdcxx-pch --disable-libssp --enable-plugin --disable-linker-build-id --enable-lto --enable-install-libiberty --with-linker-hash-style=gnu --with-gnu-ld --enable-gnu-indirect-function --disable-multilib --disable-werror --enable-checking=release --enable-default-pie --enable-default-ssp --enable-gnu-unique-object

make -j4
make install
cd ..

mkdir aarch64-gcc
cd aarch64-gcc
../gcc-*/configure --prefix=/usr/local/cross-compiler --target=aarch64-elf --enable-languages=c --enable-shared --enable-threads=posix --enable-libmpx --with-system-zlib --with-isl --enable-__cxa_atexit --disable-libunwind-exceptions --enable-clocale=gnu --disable-libstdcxx-pch --disable-libssp --enable-plugin --disable-linker-build-id --enable-lto --enable-install-libiberty --with-linker-hash-style=gnu --with-gnu-ld --enable-gnu-indirect-function --disable-multilib --disable-werror --enable-checking=release --enable-default-pie --enable-default-ssp --enable-gnu-unique-object
make -j4 all-gcc
make install-gcc
cd ..

echo "All bin files would be /usr/local/cross-compiler/bin/. If tools were compiled correctly."
echo "You can use gdb multiarch version like this: gdb-multiarch."


