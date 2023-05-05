#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y

# Step 1. Install swtpm requirements
apt install -y autoconf-archive libcmocka0 libcmocka-dev procps iproute2 build-essential git pkg-config gcc libtool automake libssl-dev uthash-dev autoconf doxygen libjson-c-dev libini-config-dev libcurl4-openssl-dev libltdl-dev expect python3-yaml libglib2.0-dev dbus  libtasn1-6-dev libjson-glib-dev gawk socat libseccomp-dev uuid-dev udev libusb-1.0-0-dev libgnutls28-dev gnutls-bin

# Step 2. Install acs requirements
apt install -y libjson-c4 libjson-c-dev mariadb-server libmysqlclient-dev git make gcc wget && rm -rf /var/lib/apt/lists

# Step 3. download submoudle
CURRENT_DIR=$(pwd)
for i in {1..5}; do
  if git submodule update --init; then
    echo "git submodule update --init succeeded"
    break
  else
    echo "git submodule update --init failed (attempt $i)"
  fi
done

# Step 4. Change to the new directory and download ibmtss1.6.0.tar.gz
mkdir $CURRENT_DIR/tpm2 && \
    cd $CURRENT_DIR/tpm2 && \
    wget https://versaweb.dl.sourceforge.net/project/ibmtpm20tss/ibmtss1.6.0.tar.gz && \
    tar zxf ibmtss1.6.0.tar.gz && \
    rm ibmtss1.6.0.tar.gz

# Step 5. Install libtpms
cd  $CURRENT_DIR/libtpms && \
    ./autogen.sh --with-tpm2 --with-openssl --prefix=/usr && \
    make -j$(nproc) && make install

# Step 6. Install swtpm
cd  $CURRENT_DIR/swtpm && \
    ./autogen.sh --prefix=/usr --with-gnutls --without-seccomp --with-tpm2  --with-openssl && \
    make -j$(nproc) && make install
    
# Step 7. Create a symbolic link from /usr/include/json-c to /usr/include/json
ln -s /usr/include/json-c /usr/include/json

# Step 8. Compile tpm2 tss
cd $CURRENT_DIR/tpm2/utils && make -f makefiletpm20 

# Step 9. Set environment
cp $CURRENT_DIR/scripts/backend/startup.sh $CURRENT_DIR/startup.sh

# Step 10. Complie client for enroll
mv $CURRENT_DIR/acs/acs $CURRENT_DIR/tpm2/acs && \
    cd $CURRENT_DIR/tpm2/acs && \
    make clientenroll && \
    bash $CURRENT_DIR/startup.sh  $CURRENT_DIR
