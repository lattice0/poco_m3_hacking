
FROM ubuntu:focal

# non root user (https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user)
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

RUN sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git-core gnupg flex bison build-essential \
        zip curl wget zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 liburcu-dev \
        lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev \
        libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig libncurses5 rsync \
        nano libssl-dev bc python2 cpio device-tree-compiler openjdk-8-jdk cmake \
        python-is-python3 abootimg brotli usbutils python3-setuptools libarchive-tools \
        qemu-kvm ninja-build python3-pip ccache language-pack-ru dos2unix unzip ed autoconf && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="${PATH}:/opt/platform_tools/platform-tools/"
# Some precompiled tools like adb
RUN sudo mkdir -p /opt/platform_tools && \
    TEMPD=$(mktemp -d) && \
    wget -O $TEMPD/platform_tools.zip https://dl.google.com/android/repository/platform-tools-latest-linux.zip -q --show-progress --progress=bar:force 2>&1 && \
    cd $TEMPD && unzip platform_tools.zip && rm platform_tools.zip && \
    sudo cp -r $TEMPD/* /opt/platform_tools

ENV PATH="/opt/repo/bin:${PATH}" 
# Repo, for cloning AOSP
RUN set -x && sudo mkdir -p /opt/repo/bin && \
    TEMPD=$(mktemp -d) && \
    wget -O $TEMPD/repo https://storage.googleapis.com/git-repo-downloads/repo && \
    sudo cp -r $TEMPD/repo /opt/repo/bin/repo && \
    sudo chmod a+rx /opt/repo/bin/repo

# Helper for extracing some .dat files
ENV PATH="${PATH}:/opt/sdat2img/sdat2img"
RUN COMMIT=b432c988a412c06ff24d196132e354712fc18929 && \
    sudo mkdir /opt/sdat2img && \
    TEMPD=$(mktemp -d) && \
    cd $TEMPD && git clone https://github.com/xpirt/sdat2img && \
    cd sdat2img && git checkout $COMMIT && \
    sudo cp -r $TEMPD/sdat2img /opt/sdat2img

# .img unpack/repack tool for Android
RUN COMMIT=d4a2677828fe9b60117af8996dcf1dea85d6b431 && \
    sudo mkdir -p /opt/mkbootimg && \
    TEMPD=$(mktemp -d) && \   
    cd $TEMPD && git clone https://github.com/osm0sis/mkbootimg && \ 
    cd mkbootimg && git checkout $COMMIT && \
    make && sudo make install && \
    sudo cp -r $TEMPD/mkbootimg /opt/mkbootimg

# Official .img unpack/repack tool for Android
ENV PATH="${PATH}:/opt/google_mkbootimg/mkbootimg"
RUN ANDROID_BRANCH=android-11.0.0_r48 && \
    COMMIT=3e4ce8371dc459d9ef6911714386399e867202af && \
    sudo mkdir -p /opt/google_mkbootimg && \
    TEMPD=$(mktemp -d) && \   
    cd $TEMPD && \
    git clone https://android.googlesource.com/platform/system/tools/mkbootimg -b $ANDROID_BRANCH && \ 
    cd mkbootimg && git checkout $COMMIT && \
    sudo cp -r $TEMPD/mkbootimg /opt/google_mkbootimg

# Official misc prebuilts
ENV PATH="${PATH}:/opt/google_misc/misc"
RUN ANDROID_BRANCH=android-11.0.0_r48 && \
    COMMIT=9ae268fc4354288daed74956df3a1dba1548abbd && \
    sudo mkdir -p /opt/google_misc && \
    TEMPD=$(mktemp -d) && \   
    cd $TEMPD && git clone https://android.googlesource.com/platform/prebuilts/misc -b $ANDROID_BRANCH && \ 
    cd misc && git checkout $COMMIT && \
    sudo cp -r $TEMPD/misc /opt/google_misc

WORKDIR /tmp

RUN cd /tmp && git clone https://github.com/ReFirmLabs/binwalk && \
    cd binwalk && sudo python3 setup.py install

RUN sudo apt-get update && sudo apt-get install -y python3-dev && \
    git clone https://github.com/theopolis/uefi-firmware-parser && \
    cd uefi-firmware-parser && sudo python3 setup.py install

RUN cd /tmp && git clone https://github.com/PabloCastellano/extract-dtb && \
    cd extract-dtb && sudo python3 setup.py install

# ---------------- Android SDK + NDK
ENV OPT_DIR /opt

ENV ANDROID_HOME=${OPT_DIR}/android-sdk-linux
ENV PATH=${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:$PATH \
    SDKMANAGER=${ANDROID_HOME}/cmdline-tools/bin/sdkmanager \
    ANDROID_NDK_VERSION=22.1.7171670
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION} \
    ANDROID_SHA256_HASH="7a00faadc0864f78edd8f4908a629a46d622375cbe2e5814e82934aebecdb622" \
    ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip" 

RUN set -ex && sudo mkdir ${ANDROID_HOME} && curl -sSL -o android-sdk.zip ${ANDROID_SDK_URL} \
    && echo "${ANDROID_SHA256_HASH} *android-sdk.zip" | shasum -a 256 --check \
    && TEMPD=$(mktemp -d) \
    && unzip android-sdk.zip -d ${TEMPD} && rm android-sdk.zip \
    && sudo mv ${TEMPD}/* ${ANDROID_HOME}/ \
    && rm -rf ${TEMPD} \
    && sudo chown $USERNAME:$USERNAME $ANDROID_HOME -R \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} --list \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "build-tools;25.0.1" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "build-tools;28.0.3" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "build-tools;29.0.2" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "build-tools;30.0.3" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "platform-tools" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "platforms;android-25" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "platforms;android-28" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "platforms;android-30" \ 
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "extras;android;m2repository" \
    && echo y | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "extras;google;google_play_services" \
    && ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "ndk;${ANDROID_NDK_VERSION}" \
    && ${SDKMANAGER} --sdk_root=${ANDROID_HOME} "cmake;3.18.1" \
    && yes | ${SDKMANAGER} --sdk_root=${ANDROID_HOME} --update \
    && sudo chown $USERNAME:$USERNAME $ANDROID_HOME -R
# ------------------------------------

RUN sudo apt-get update && sudo apt install -y libusb-1.0-0-dev libusb-dev \
    && git clone https://github.com/Benjamin-Dobell/Heimdall/ && cd Heimdall \
    && cmake -D DISABLE_FRONTEND=true . \
    && make && sudo make install

RUN sudo mkdir /opt/entrypoint && \ 
    TEMPD=$(mktemp -d) && \   
    echo "#!/bin/sh\n\
source /home/project/source_me.sh\n\
exec \"\$@\"" > $TEMPD/entrypoint.sh && \
    sudo cp $TEMPD/entrypoint.sh /opt/entrypoint

RUN cat /opt/entrypoint/entrypoint.sh 

RUN git config --global color.ui true

ENV PATH="/home/dev/.cargo/bin/:${PATH}"
RUN /bin/bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
RUN rustup target add aarch64-linux-android
RUN cargo install cargo-ndk

#RUN sudo apt install -y llvm clang clang-tools gcc-aarch64-linux-gnu

RUN sudo locale-gen en_US en_US.UTF-8

RUN sudo usermod -aG plugdev dev

WORKDIR /home/dev/project