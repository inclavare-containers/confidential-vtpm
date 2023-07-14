# Environment

OS: Ubuntu 20.04

# Requirements

Step.1 Install the Docker
If you have installed the Docker, skip it
or you can visit https://docs.docker.com/engine/install/debian/ 

Step.2 Build the Verifier Docker Image
```sh
cp hacks/acs/0001-del-ekcert-verify.patch scripts/verifier/ 
docker build -t acs:0.1 scripts/verifier/
docker run -d -p 2323:2323 -it acs:0.1 bash /root/startup.sh >/dev/null 2>&1
```

Step.3 TPM Backend
```sh
cd  scripts/backend && bash build.sh
```



Step.4 TPM Frontend
```sh
bash scripts/frontend/frontend.sh
```

If you see that the virtual machine has successfully started, it means that the frontend and backend can communicate with each other. You can also enter the virtual machine (root: 123456) and check if the TPM is detected by running the following command:
```sh
dmesg | grep tpm 
```

If you see the following message, it means that the QEMU VM establishs the communication channel with the Software TPM successfully:
```sh
[    x.xxxxxx] tpm_tis MSFT0101:00: 2.0 TPM (device-id 0x1, rev-id 1)
```
