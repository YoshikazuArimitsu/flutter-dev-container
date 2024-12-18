FROM ubuntu:24.04

#Locale
ENV LANG ja_JP.UTF-8

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN  apt update \
	&& apt install -y sudo \
	# && apt install -y openjdk-11-jdk-headless --no-install-recommends \
	&& apt install -y openjdk-17-jdk-headless --no-install-recommends \
	&& apt install -y wget curl git xz-utils zip unzip sudo --no-install-recommends 
	
RUN	apt-get autoremove -y \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/* 

# RUN	groupadd --gid $USER_GID $USERNAME \
# 	&& useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
# 	&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
# 	&& chmod 0440 /etc/sudoers.d/$USERNAME \
# 	&& chmod go+w /usr/local/bin/ \
# 	&& su $USERNAME \
# 	&& cd /home/${USERNAME}

RUN	echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
 	&& chmod 0440 /etc/sudoers.d/$USERNAME \
 	&& chmod go+w /usr/local/bin/ \
 	&& su $USERNAME \
 	&& cd /home/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Android ToolChain
ENV ANDROID_SDK_ROOT=/home/${USERNAME}/android-sdk-linux
ENV ANDROID_SDK_TOOLS_VERSION=8512546
ENV ANDROID_PLATFORM_VERSION=29
ENV ANDROID_BUILD_TOOLS_VERSION=33.0.0
RUN <<EOF
export ANDROID_TOOLS_FILENAME="commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip"
wget https://dl.google.com/android/repository/$ANDROID_TOOLS_FILENAME -P ~ > /dev/null
unzip ~/$ANDROID_TOOLS_FILENAME -d ~ > /dev/null 2>&1
mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools
mv ~/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest
export PATH=$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/cmdline-tools/platform-tools
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-$ANDROID_PLATFORM_VERSION" > /dev/null
sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" > /dev/null
EOF

ENV PATH $PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Flutter SDK
ENV FLUTTER_VERSION="3.27.0"

RUN <<EOF
curl -fsSL https://fvm.app/install.sh | bash
export PATH=/home/${USERNAME}/fvm/default/bin:$PATH
fvm install ${FLUTTER_VERSION} --setup
fvm use ${FLUTTER_VERSION} --fvm-skip-input
fvm global ${FLUTTER_VERSION}
EOF

ENV PATH /home/${USERNAME}/fvm/default/bin:$PATH

# WSL用 ホスト側adb-serverに接続する
ENV ADB_SERVER_SOCKET tcp:172.30.48.1:5037

CMD ["/bin/bash"]