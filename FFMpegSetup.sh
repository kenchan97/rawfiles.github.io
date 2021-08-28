#!/bin/sh
echo "========================Start FFMPEG Setup========================"
################################################################FFMPEG
##https://superuser.com/questions/1214396/how-to-compile-ffmpeg-with-h-265-h-264-and-vp9-support-on-centos/1226089

yum remove -y nasm
yum install -y autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel x264-devel
yum install -y openssl openssl-devel

rm -rf ~/ffmpeg_sources
mkdir ~/ffmpeg_sources
cd ~/ffmpeg_sources
curl -O -L http://www.nasm.us/pub/nasm/releasebuilds/2.13.02/nasm-2.13.02.tar.bz2
tar xjvf nasm-2.13.02.tar.bz2
cd nasm-2.13.02
./autogen.sh
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install


cd ~/ffmpeg_sources
curl -O -L http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install

echo "========================Start H264 Setup========================"
####################H.264
cd ~/ffmpeg_sources
git clone --depth 1 http://git.videolan.org/git/x264.git
cd x264
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
PATH="$HOME/bin:$PATH" make
PATH="$HOME/bin:$PATH" make install
echo "========================Start H265 Setup========================"
####################H.265
cd ~/ffmpeg_sources
hg clone http://hg.videolan.org/x265
cd ~/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install

echo "========================Start AAC Setup========================"
######################aac
cd ~/ffmpeg_sources
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install

######################ogg
cd ~/ffmpeg_sources
curl -O -L http://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.gz
tar xzvf libogg-1.3.5.tar.gz
cd libogg-1.3.5
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install 
cd ~/ffmpeg_sources
curl -O -L http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.gz
tar xzvf libvorbis-1.3.7.tar.gz
cd libvorbis-1.3.7
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make
make install 
cd ~/ffmpeg_sources
curl -O -L https://ftp.osuosl.org/pub/xiph/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make
make install 
echo "========================Start MAKR INSTALL Setup========================"
mv /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg_old
mv /root/bin/ffmpeg /root/bin/ffmpeg_old
cd ~/ffmpeg_sources
curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
rm -rf ffmpeg
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --pkg-config-flags="--static" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --extra-libs=-lpthread --extra-libs=-lm --bindir="$HOME/bin" --enable-gpl --enable-libfdk_aac --enable-libx264 --enable-libx265 --enable-libvorbis --enable-libtheora --enable-nonfree --enable-openssl
PATH="$HOME/bin:$PATH" make
PATH="$HOME/bin:$PATH" make install
hash -r
ffmpeg -version
ffmpeg -encoders | grep H.26

################################################################FFMPEG
echo "========================FINISHED FFMPEG Setup========================"
