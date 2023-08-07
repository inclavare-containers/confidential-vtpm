#!/bin/bash
set -e
git submodule update --init
cp -r  ../../libtpms libtpms
cp -r  ../../swtpm swtpm 
docker build -t occlum_swtpm .
rm -rf libtpms
rm -rf swtpm
docker run -d -p 2321:2321   -p 2322:2322   --device /dev/sgx/enclave --device /dev/sgx/provision occlum_swtpm   /root/start.sh   
