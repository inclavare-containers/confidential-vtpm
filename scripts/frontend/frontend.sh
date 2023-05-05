#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Step 1. Install dependencies
apt-get update -y && apt install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build libcap-ng-dev libslirp-dev

# Step 2. Install qemu 
for i in {1..5}; do
  if git submodule update --init; then
    echo "git submodule update --init succeeded"
    break
  else
    echo "git submodule update --init failed (attempt $i)"
  fi
done

if ! command -v qemu-system-x86_64 >/dev/null 2>&1;
then
    cd qemu
    ./configure --prefix=/usr --enable-debug --target-list=x86_64-softmmu --enable-kvm --enable-virtfs --enable-slirp || handle_error "submoudle qemu not benn downloaded"
    make -j$(nproc)
    make install
    cd ..
else
    echo "qemu is installed"
fi

# Step 3. Download VM image
if [ -f "./focal-server-cloudimg-amd64.img" ]
then
    echo "File exists"
else
    wget https://cloud-images.ubuntu.com/focal/20230420/focal-server-cloudimg-amd64.img
fi

# Step 4. config VM name and password
read -p "Enter username: " username
read -p "Enter password: " password
password=$(openssl passwd -1 $password)
modprobe nbd max_part=63
qemu-nbd -c /dev/nbd0 focal-server-cloudimg-amd64.img
sleep 5
mount /dev/nbd0p1 /mnt
sed -i "s#^$username:.*#$username:$password:18472:0:99999:7:::#" /mnt/etc/shadow
umount /mnt
qemu-nbd -d /dev/nbd0

# Step 5. Launch swtpm
mkdir /tmp/mytpm2
swtpm socket --tpmstate dir=/tmp/mytpm2 \
    --ctrl type=unixio,path=/tmp/mytpm2/swtpm-sock \
    --log level=20 --tpm2 &  >/dev/null 2>&1 

# Step 6. Launch VM
qemu-system-x86_64 -enable-kvm -m 2048  -nographic \
    -netdev user,id=vmnic -net user,hostfwd=tcp::10021-:22 \
    -net nic,model=e1000 \
    -device e1000,netdev=vmnic,romfile= \
    -hda  focal-server-cloudimg-amd64.img \
    -chardev socket,id=chrtpm,path=/tmp/mytpm2/swtpm-sock \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0

handle_error() {
  echo "An error occurred: \$1"
  exit 1
}
