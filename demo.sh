# helper function
function restart_etpm_container (){
	docker stop rte_etpm_instance
	docker rm rte_etpm_instance
        docker run -itd --name rte_etpm_instance --privileged -v /dev/sgx_enclave:/dev/sgx/enclave -v /dev/sgx_provision:/dev/sgx/provision --net=host docker4ctf/etpm_container:etpm_v0.2
        docker exec rte_etpm_instance occlum run /bin/tpm2-simulator &
        sleep 5
}

# Unit tests
unit_tests="test/unit/test_string_bytes \
	test/unit/test_files \
	test/unit/test_tpm2_header \
	test/unit/test_tpm2_attr_util \
	test/unit/test_tpm2_alg_util \
	test/unit/test_pcr \
	test/unit/test_tpm2_auth_util \
	test/unit/test_tpm2_errata \
	test/unit/test_tpm2_session \
	test/unit/test_tpm2_policy \
	test/unit/test_tpm2_util \
	test/unit/test_options \
	test/unit/test_cc_util \
	test/unit/test_tpm2_eventlog \
	test/unit/test_tpm2_eventlog_yaml"

# Integration tests 1
integration_tests_1="test/integration/tests/X509certutil.sh\
        test/integration/tests/abrmd_extended-sessions.sh\
        test/integration/tests/abrmd_nvundefinespecial.sh\
        test/integration/tests/abrmd_policyauthorize.sh\
        test/integration/tests/abrmd_policyauthorizenv.sh \
        test/integration/tests/abrmd_policyauthvalue.sh \
        test/integration/tests/abrmd_policycommandcode.sh"
# Integration tests 2
integration_tests_2="test/integration/tests/abrmd_policycountertimer.sh \
        test/integration/tests/abrmd_policycphash.sh \
        test/integration/tests/abrmd_policyduplicationselect.sh \
        test/integration/tests/abrmd_policynamehash.sh \
        test/integration/tests/abrmd_policynv.sh \
        test/integration/tests/abrmd_policynvwritten.sh \
        test/integration/tests/abrmd_policyor.sh \
        test/integration/tests/abrmd_policypassword.sh \
        test/integration/tests/abrmd_policypcr.sh \
        test/integration/tests/abrmd_policysecret.sh \
        test/integration/tests/abrmd_policysigned.sh"
# Integration tests 3
integration_tests_3="test/integration/tests/abrmd_policytemplate.sh \
        test/integration/tests/abrmd_policyticket.sh \
        test/integration/tests/activecredential.sh \
        test/integration/tests/attestation.sh \
        test/integration/tests/certify.sh \
        test/integration/tests/certifycreation.sh \
        test/integration/tests/changeauth.sh \
        test/integration/tests/changeeps.sh \
        test/integration/tests/changepps.sh \
        test/integration/tests/checkquote.sh \
        test/integration/tests/clear.sh \
        test/integration/tests/clearcontrol.sh \
        test/integration/tests/clockrateadjust.sh \
        test/integration/tests/commandaudit.sh \
        test/integration/tests/create.sh"
integration_tests_4="test/integration/tests/createak.sh \
        test/integration/tests/createek.sh \
        test/integration/tests/createpolicy.sh \
        test/integration/tests/createprimary.sh \
        test/integration/tests/dictionarylockout.sh \
        test/integration/tests/duplicate.sh \
        test/integration/tests/ecc.sh \
        test/integration/tests/encryptdecrypt.sh \
        test/integration/tests/eventlog.sh \
        test/integration/tests/evictcontrol.sh \
        test/integration/tests/flushcontext.sh \
        test/integration/tests/getcap.sh \
        test/integration/tests/getekcertificate.sh \
        test/integration/tests/getpolicydigest.sh \
        test/integration/tests/getrandom.sh \
        test/integration/tests/gettestresult.sh \
        test/integration/tests/gettime.sh \
        test/integration/tests/hash.sh \
        test/integration/tests/hierarchycontrol.sh \
        test/integration/tests/hmac.sh"
integration_tests_5="test/integration/tests/import.sh \
        test/integration/tests/import_tpm.sh \
        test/integration/tests/incrementalselftest.sh \
        test/integration/tests/load.sh \
        test/integration/tests/loadexternal.sh \
        test/integration/tests/makecredential.sh \
        test/integration/tests/nv.sh \
        test/integration/tests/nvcertify.sh \
        test/integration/tests/nvinc.sh \
        test/integration/tests/output_formats.sh \
        test/integration/tests/pcrallocate.sh \
        test/integration/tests/pcrevent.sh \
        test/integration/tests/pcrextend.sh \
        test/integration/tests/pcrlist.sh \
        test/integration/tests/pcrreset.sh \
        test/integration/tests/pcrs_format.sh \
        test/integration/tests/print.sh \
        test/integration/tests/quote.sh \
        test/integration/tests/rc_decode.sh \
        test/integration/tests/readclock.sh \
        test/integration/tests/readpublic.sh \
        test/integration/tests/rsadecrypt.sh \
        test/integration/tests/rsaencrypt.sh \
        test/integration/tests/selftest.sh \
        test/integration/tests/send-tcti-cmd.sh \
        test/integration/tests/send.sh \
        test/integration/tests/sessionaudit.sh \
        test/integration/tests/sessionconfig.sh \
        test/integration/tests/setclock.sh \
        test/integration/tests/setprimarypolicy.sh"
integration_tests_6="test/integration/tests/sign.sh \
        test/integration/tests/startup.sh \
        test/integration/tests/stirrandom.sh \
        test/integration/tests/symlink.sh \
        test/integration/tests/testparms.sh \
        test/integration/tests/toggle_options.sh \
        test/integration/tests/unseal.sh \
        test/integration/tests/verifysignature.sh"
# Integration tests 3
FAPI_TESTS="test/integration/fapi/fapi-authorize-policy.sh \
        test/integration/fapi/fapi-authorize-policy_ecc.sh \
        test/integration/fapi/fapi-branch-select.sh \
        test/integration/fapi/fapi-branch-select_ecc.sh \
        test/integration/fapi/fapi-encrypt-decrypt.sh \
        test/integration/fapi/fapi-encrypt-decrypt_ecc.sh \
        test/integration/fapi/fapi-export-key.sh \
        test/integration/fapi/fapi-export-key_ecc.sh \
        test/integration/fapi/fapi-export-policy.sh \
        test/integration/fapi/fapi-export-policy_ecc.sh \
        test/integration/fapi/fapi-get-info.sh \
        test/integration/fapi/fapi-get-info_ecc.sh \
        test/integration/fapi/fapi-get-platform-certificates.sh \
        test/integration/fapi/fapi-get-platform-certificates_ecc.sh \
        test/integration/fapi/fapi-get-random.sh \
        test/integration/fapi/fapi-get-random_ecc.sh \
        test/integration/fapi/fapi-get-tpm-blobs.sh \
        test/integration/fapi/fapi-get-tpm-blobs_ecc.sh \
        test/integration/fapi/fapi-gettpm2object.sh \
        test/integration/fapi/fapi-gettpm2object_ecc.sh \
        test/integration/fapi/fapi-key-change-auth.sh \
        test/integration/fapi/fapi-key-change-auth_ecc.sh \
        test/integration/fapi/fapi-list.sh \
        test/integration/fapi/fapi-list_ecc.sh \
        test/integration/fapi/fapi-nv-extend.sh \
        test/integration/fapi/fapi-nv-extend_ecc.sh \
        test/integration/fapi/fapi-nv-increment.sh \
        test/integration/fapi/fapi-nv-increment_ecc.sh \
        test/integration/fapi/fapi-nv-set-bits.sh \
        test/integration/fapi/fapi-nv-set-bits_ecc.sh \
        test/integration/fapi/fapi-nv-write-authorize.sh \
        test/integration/fapi/fapi-nv-write-authorize_ecc.sh \
        test/integration/fapi/fapi-nv-write-read-policy-or.sh \
        test/integration/fapi/fapi-nv-write-read-policy-or2.sh \
        test/integration/fapi/fapi-nv-write-read-policy-or2_ecc.sh \
        test/integration/fapi/fapi-nv-write-read-policy-or_ecc.sh \
        test/integration/fapi/fapi-nv-write-read.sh \
        test/integration/fapi/fapi-nv-write-read_ecc.sh \
        test/integration/fapi/fapi-pcr-extend-read.sh \
        test/integration/fapi/fapi-pcr-extend-read_ecc.sh \
        test/integration/fapi/fapi-policy_signed.sh \
        test/integration/fapi/fapi-policy_signed_delegation.sh \
        test/integration/fapi/fapi-policy_signed_delegation_ecc.sh \
        test/integration/fapi/fapi-policy_signed_ecc.sh \
        test/integration/fapi/fapi-provision.sh \
        test/integration/fapi/fapi-provision_ecc.sh \
        test/integration/fapi/fapi-quote-verify.sh \
        test/integration/fapi/fapi-quote-verify_ecc.sh \
        test/integration/fapi/fapi-seal-unseal.sh \
        test/integration/fapi/fapi-seal-unseal_ecc.sh \
        test/integration/fapi/fapi-set-get-app-data.sh \
        test/integration/fapi/fapi-set-get-app-data_ecc.sh \
        test/integration/fapi/fapi-set-get-certificate.sh \
        test/integration/fapi/fapi-set-get-certificate_ecc.sh \
        test/integration/fapi/fapi-set-get-description.sh \
        test/integration/fapi/fapi-set-get-description_ecc.sh \
        test/integration/fapi/fapi-sign-verify.sh \
        test/integration/fapi/fapi-sign-verify_ecc.sh \
        test/integration/fapi/fapi-testing-template.sh \
        test/integration/fapi/fapi-testing-template_ecc.sh"


# 1.Run the Container under the same network
docker run -itd --name rte_etpm_instance --privileged -v /dev/sgx_enclave:/dev/sgx/enclave -v /dev/sgx_provision:/dev/sgx/provision --net=host docker4ctf/etpm_container:etpm_v0.2
docker run -itd --name rte_tss2_instance --privileged --net=host docker4ctf/etpm_container:tss2_v0.2
docker exec rte_tss2_instance ldconfig -v | grep tss2-esys


tmux new -d -s etpm_demo0
tmux split-window -h
# 2.Launch eTPM
tmux send-keys -t etpm_demo0:0.0 \
        "docker run -itd --name rte_etpm_instance --privileged -v /dev/sgx_enclave:/dev/sgx/enclave -v /dev/sgx_provision:/dev/sgx/provision --net=host docker4ctf/etpm_container:etpm_v0.2" ENTER\
	"docker exec rte_etpm_instance occlum run /bin/tpm2-simulator &" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$unit_tests\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-unit_tests.log" ENTER

########################################
tmux send-keys -t etpm_demo0:0.0 \
	"restart_etpm_container" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$integration_tests_1\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-integration_tests_1.log" ENTER

#######################################
tmux send-keys -t etpm_demo0:0.0 \
	"restart_etpm_container" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$integration_tests_2\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-integration_tests_2.log" ENTER

########################################
tmux send-keys -t etpm_demo0:0.0 \
	"restart_etpm_container" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$integration_tests_3\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-integration_tests_3.log" ENTER

########################################
tmux send-keys -t etpm_demo0:0.0 \
	"restart_etpm_container" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$integration_tests_4\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-integration_tests_4.log" ENTER

########################################
tmux send-keys -t etpm_demo0:0.0 \
	"restart_etpm_container" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$integration_tests_5\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-integration_tests_5.log" ENTER

########################################
tmux send-keys -t etpm_demo0:0.0 \
	"restart_etpm_container" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$integration_tests_6\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-integration_tests_6.log" ENTER

########################################
tmux send-keys -t etpm_demo0:0.0 \
	"restart_etpm_container" ENTER

tmux send-keys -t etpm_demo0:0.1 \
        "docker exec rte_tss2_instance make check TPM2TOOLS_TCTI=\"mssim:host=localhost,port=2321\" TPM2ABRMD_TCTI=\"--session --dbus-name=com.intel.tss2.Tabrmd2321 --tcti=mssim:host=localhost,port=2321\" TPM2TOOLS_TEST_TCTI=\"tabrmd:bus_type=session,bus_name=com.intel.tss2.Tabrmd2321\" TSS2_LOG=tcti+DEBUG TESTS=\"$FAPI_TESTS\"" ENTER\
        "docker cp rte_tss2_instance:/root/tpm2-tools/test-suite.log $PWD/test-suite-FAPI_TESTS.log" ENTER

########################################
tmux send-keys -t etpm_demo0:0.0 \
	"docker stop rte_etpm_instance" ENTER\
        "docker rm rte_etpm_instance" ENTER
tmux send-keys -t etpm_demo0:0.0 \
	"docker stop rte_tss2_instance" ENTER\
        "docker rm rte_tss2_instance" ENTER	
	
tmux kill-server