#!/bin/bash
set -e
occlum run /bin/swtpm socket --tpmstate dir=/tmp/tpmstate  --ctrl type=tcp,port=2322 --log level=20 --tpm2 --server type=tcp,port=2321
bash 
