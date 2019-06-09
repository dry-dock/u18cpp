#!/bin/bash -e

echo "================= Adding some global settings =================="
mkdir -p "$HOME/.ssh/"
mv /u18cpp/config "$HOME/.ssh/"
mv /u18cpp/90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "========================= Clean apt-get ========================"
apt-get clean
mv /var/lib/apt/lists/* /tmp
mkdir -p /var/lib/apt/lists/partial
apt-get clean
apt-get update
echo "======================== Cleaned apt-get ======================="

echo "================= Installing basic packages ===================="
apt-get update && apt-get install -y \
sudo \
software-properties-common \
wget \
curl \
openssh-client \
ftp \
gettext \
smbclient

echo "================= Installing Python packages =================="
apt-get install -q -y \
python-pip \
python2.7-dev

pip install -q virtualenv==16.5.0
pip install -q pyOpenSSL==19.0.0


export JQ_VERSION=1.5*
echo "================= Adding JQ $JQ_VERSION ========================="
apt-get install -y -q jq="$JQ_VERSION"

echo "================= Installing CLIs packages ======================"

export GIT_VERSION=1:2.*
echo "================= Installing Git $GIT_VERSION ===================="
add-apt-repository ppa:git-core/ppa -y
apt-get update -qq
apt-get install -y -q git="$GIT_VERSION"

export CLOUD_SDKREPO=249.0*
echo "================= Adding gcloud $CLOUD_SDK_REPO =================="
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get -y install google-cloud-sdk="$CLOUD_SDKREPO"

export AWS_VERSION=1.16.173
echo "================= Adding awscli $AWS_VERSION ===================="
sudo pip install awscli=="$AWS_VERSION"

export AWSEBCLI_VERSION=3.15.2
echo "================= Adding awsebcli $AWSEBCLI_VERSION =============="
sudo pip install awsebcli=="$AWSEBCLI_VERSION"

AZURE_CLI_VERSION=2.0*
echo "================ Adding azure-cli $AZURE_CLI_VERSION =============="
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install -q apt-transport-https
sudo apt-get update && sudo apt-get install -y -q azure-cli=$AZURE_CLI_VERSION

JFROG_VERSION=1.25.0
echo "================= Adding jfrog-cli $JFROG_VERSION  ================"
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/"$JFROG_VERSION"/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

echo "======================= Installing gcc 9.1.0 ======================"
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update
apt-get install -y \
  gcc-9=9* \
  g++-9=9*
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9
update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-9 90
gcc --version
echo "================== Successfully Installed gcc 9.1.0 ==============="

echo "=================== Install packages for cpp ======================"

apt-get install && apt-get install -y \
  autoconf \
  automake \
  ccache \
  libssl-dev

CLANG_VERSION=8.0.0
echo "==================== Installing clang $CLANG_VERSION ==============="
wget -nv http://releases.llvm.org/"$CLANG_VERSION"/clang+llvm-"$CLANG_VERSION"-x86_64-linux-gnu-ubuntu-18.04.tar.xz
tar xf clang+llvm-"$CLANG_VERSION"-x86_64-linux-gnu-ubuntu-18.04.tar.xz
cd clang+llvm-"$CLANG_VERSION"-x86_64-linux-gnu-ubuntu-18.04
cp -R * /usr/local/
cd ../
clang --version
echo "============= Successfully Installed clang $CLANG_VERSION ==========="
