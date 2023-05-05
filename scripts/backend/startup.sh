export CPATH=$1/tpm2/utils
export LD_LIBRARY_PATH=$1/tpm2/utils:$1/tpm2/utils12“
export TPM_DATA_DIR=$1/tpm2
export TPM_SERVER_TYPE=mssim
export ACS_PORT=2323

mkdir /tmp/mytpm1
swtpm_setup --tpmstate /tmp/mytpm1 --create-ek-cert --create-platform-cert  --tpm2 --display
swtpm socket --tpmstate dir=/tmp/mytpm1 --ctrl type=unixio,path=/tmp/mytpm1/swtpm-sock --log level=20 --tpm2 --server type=tcp,port=2321 &
sleep 3 
swtpm_ioctl -i --unix /tmp/mytpm1/swtpm-sock
swtpm_bios --tpm2 --tcp :2321
cd $1/tpm2/acs
./clientenroll -alg rsa -vv -ho localhost  -co akcert.pem
