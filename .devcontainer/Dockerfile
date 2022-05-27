
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

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git-core gnupg flex bison build-essential \
        zip curl wget zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
        lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev \
        libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig libncurses5 rsync \
        nano libssl-dev bc python2 cpio device-tree-compiler openjdk-8-jdk \
        python-is-python3 abootimg brotli usbutils python3-setuptools libarchive-tools \
        qemu-kvm ninja-build python3-pip ccache language-pack-ru && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Some precompiled tools like adb
RUN mkdir /opt/platform_tools && \
    wget -O /opt/platform_tools/platform_tools.zip https://dl.google.com/android/repository/platform-tools-latest-linux.zip -q --show-progress --progress=bar:force 2>&1 && \
    cd  /opt/platform_tools/ && unzip platform_tools.zip && rm platform_tools.zip

ENV PATH="/opt/repo/bin:${PATH}" 
ENV PATH="${PATH}:/opt/platform_tools/platform-tools/"

# Repo, for cloning AOSP
RUN mkdir -p /opt/repo/bin && curl https://storage.googleapis.com/git-repo-downloads/repo > /opt/repo/bin/repo \
    && chmod a+rx /opt/repo/bin/repo

# Helper for extracing some .dat files
ENV PATH="${PATH}:/opt/sdat2img/sdat2img"
RUN COMMIT=b432c988a412c06ff24d196132e354712fc18929 && \
    mkdir /opt/sdat2img && cd /opt/sdat2img && git clone https://github.com/xpirt/sdat2img && \
    cd sdat2img && git checkout $COMMIT

# .img unpack/repack tool for Android
RUN COMMIT=d4a2677828fe9b60117af8996dcf1dea85d6b431 && \
    mkdir -p /opt/mkbootimg && cd /opt/mkbootimg && \
    git clone https://github.com/osm0sis/mkbootimg && \ 
    cd mkbootimg && git checkout $COMMIT && \
    make && make install

# Official .img unpack/repack tool for Android
ENV PATH="${PATH}:/opt/google_mkbootimg/mkbootimg"
RUN ANDROID_BRANCH=android-11.0.0_r48 && \
    COMMIT=3e4ce8371dc459d9ef6911714386399e867202af && \
    mkdir -p /opt/google_mkbootimg && cd /opt/google_mkbootimg && \
    git clone https://android.googlesource.com/platform/system/tools/mkbootimg -b $ANDROID_BRANCH && \ 
    cd mkbootimg && git checkout $COMMIT 

# Official misc prebuilts
ENV PATH="${PATH}:/opt/google_misc/misc"
RUN ANDROID_BRANCH=android-10.0.0_r47 && \
    COMMIT=f1a323aedf4871c698e2186526631a48afa2fb89 && \
    mkdir -p /opt/google_misc && cd /opt/google_misc && \
    git clone https://android.googlesource.com/platform/prebuilts/misc -b $ANDROID_BRANCH && \ 
    cd misc && git checkout $COMMIT 

RUN cd /tmp && git clone https://github.com/ReFirmLabs/binwalk && \
    cd binwalk && python3 setup.py install

RUN apt-get update && apt-get install -y python3-dev && \
    git clone https://github.com/theopolis/uefi-firmware-parser && \
    cd uefi-firmware-parser && python3 setup.py install

RUN cd /tmp && git clone https://github.com/PabloCastellano/extract-dtb && \
    cd extract-dtb && python3 setup.py install

RUN mkdir /opt/entrypoint && cd /opt/entrypoint && echo "#!/bin/sh\n\
source /home/project/source_me.sh\n\
exec \"\$@\"" > entrypoint.sh

RUN cat /opt/entrypoint/entrypoint.sh 

RUN git config --global color.ui true

#RUN git config --global user.name "Lattice 0" && \
#    git config --global user.email "lattice0@protonmail.com" && \
#    git config --global color.ui true

RUN /bin/bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

WORKDIR /home/project

#RUN useradd -ms /bin/bash  user
#USER user
