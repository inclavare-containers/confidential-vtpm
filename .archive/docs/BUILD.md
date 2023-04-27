# Requirement
## Platform
Intel CPU with SGX support
Aliyun vSGX ECS instance
## OS Release Version
Aliyun Linux 3 (**RECOMMEND!**)
## Kernel Version
5.10.112-11.1.al8.x86_64
## Dependencies
* SGX driver
* SGX SDK
In Aliyun vSGX ECS instance, the former two dependencies is build-in components. If you were to construct the SGX development environment from scratch, you can find the solution in the [Intel SGX homepage](https://www.intel.com/content/www/us/en/developer/tools/software-guard-extensions/overview.html).
* Docker
This porject is incubating in the Occlum docker image, it is convenient for you to make further improvement on top of it. Alternatively, to use Occlum without Docker, you can find the solution in the [Occlum project](https://github.com/occlum/occlum).
* tmux

## Build

### Build with Dockerfile

1. Build docker image (Optional)

    ```sh
    cd etpm
    # sh build.sh
    docker build -f etpm/etpm-Dockerfile -t docker4ctf/etpm_container:etpm_v0.2 .
	docker build -f tss2/tss2-Dockerfile -t docker4ctf/etpm_container:tss2_v0.2 .
    ```

1. You can also Download the prebuilded Docker image

    ```sh
    cd etpm
    # sh download.sh
	docker pull docker4ctf/etpm_container:etpm_v0.2
	docker pull docker4ctf/etpm_container:tss2_v0.2
    ```
    
2. Start container

    ```sh
    docker run -itd --name rte_etpm_instance --privileged \
	    -v /dev/sgx_enclave:/dev/sgx/enclave \
	    -v /dev/sgx_provision:/dev/sgx/provision \
	    --net=host \
	    docker4ctf/etpm_container:etpm_v0.2
	docker run -itd --name rte_tss2_instance --privileged \
		--net=host \
		docker4ctf/etpm_container:tss2_v0.2
    ```

3. Single Case Testing

    ```sh
	# launch etpm-simulator
	docker exec rte_etpm_instance occlum run /bin/tpm2-simulator &
	# launch testing commands
	docker exec rte_tss2_instance \
		make check TPM2TOOLS_TCTI="mssim:host=localhost,port=2321"\
		TPM2ABRMD_TCTI="--session --dbus-name=com.intel.tss2.Tabrmd2321 \
		--tcti=mssim:host=localhost,port=2321"\
		TPM2TOOLS_TEST_TCTI="tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321"\
		TSS2_LOG=tcti+DEBUG TESTS=<test_case_name>.sh
    ```

The test scripts in tpm2-tools is used for the case, tpm-simulator and TSS are deployed in the same system. It is not suitable for our scenarios. So we modify the helpers.sh and Interlace the run-stop of container during the execution of One-Click Script. You can run the whole set of test scripts by `sh demo.sh`

For more information about the demo, check out [this doc](../docs/Desgin.md).