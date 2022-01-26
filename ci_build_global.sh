#!/bin/bash
set -e
. setdevkitpath.sh

export JDK_DEBUG_LEVEL=release

if [ "$BUILD_IOS" != "1" ]; then
  sudo apt update
  sudo apt -y install autoconf python unzip zip

#  wget -nc -nv -O android-ndk-$NDK_VERSION-linux-x86_64.zip "https://dl.google.com/android/repository/android-ndk-$NDK_VERSION-linux-x86_64.zip"
#  ./extractndk.sh
  export NDK=$ANDROID_NDK_HOME
  [[ "$CACHED_TOOLCHAIN" != "1" ]] && ./maketoolchain.sh
  # build libapi19.a
  chmod +x ./api19.sh && $_
else
  # OpenJDK 8 iOS port is still in unusable state, so we need build in debug mode
  export JDK_DEBUG_LEVEL=slowdebug

  chmod +x ios-arm64-clang
  chmod +x ios-arm64-clang++
  chmod +x macos-host-cc
fi

# Some modifies to NDK to fix

./getlibs.sh
./buildlibs.sh
./clonejdk.sh
cp -R api19 openjdk/src/
./buildjdk.sh
./removejdkdebuginfo.sh
./tarjdk.sh
