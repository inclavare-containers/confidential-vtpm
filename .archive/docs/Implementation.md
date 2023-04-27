## About the Code

This project is implemented based on [Microsoft TPM Simulator](https://github.com/microsoft/ms-tpm-20-ref), [Occlum](https://github.com/occlum/occlum), [Rats-TLS](https://github.com/inclavare-containers/rats-tls) and  "tpm2 three-piece suite" accommodated with [tpm2-tss](https://github.com/tpm2-software/tpm2-tss), [tpm2-abrmd](https://github.com/tpm2-software/tpm2-tss), [tpm2-tools](https://github.com/tpm2-software/tpm2-tss) provided by tpm2-software community. These projects are implemented in C language. Their description are as follows (Excerpt from their docs):

>Microsoft TPM Simulator: This is the official TCG reference implementation of the [TPM 2.0 Specification](https://trustedcomputinggroup.org/tpm-library-specification).
>Occlum is a memory-safe, multi-process library OS (LibOS) for Intel SGX.
>Rats-TLS: a mutual transport layer security protocol that supports heterogeneous hardware executable environments.
>tpm2-tss: This repository hosts source code implementing the Trusted Computing Group's (TCG) TPM2 Software Stack (TSS).
>tpm2-abrmd: This is a system daemon implementing the TPM2 access broker (TAB) & Resource Manager (RM) spec from the TCG.
>tpm2-tools: The source repository for the Trusted Platform Module (TPM2.0) tools based on tpm2-tss

## TPM Simulator Side

In the current design, the etpm's responsibility is to provides encryption, attestion and other safety-critical services.  As mentioned above, Occlum and Rats-TLS protect the security of storage and communication respectively. Occlum LibOS designs a effective encrypted file system to protect the storage of eTPM. We can run unmodified vTPM in the SGX enclave supported by Occlum. Rats-TLS leverages the mechanism of remote attestion to gurantee the security of communication. 

Different from the socket programming, Rats-TLS uses the handle as UUID of two sides. We retrofitted the entry function processing the Platform Commands and TPM Commands like `PlatformServer`, `PlatformSvcRoutine`, `RegularCommandService`, and wrapper function responsible for communication like `ReadBytes`, `WriteBytes`, `WriteUINT32`, `ReadUINT32`, `ReadVarBytes`, `WriteVarBytes`. The main contribution is replacement the socket using Rats-TLS handle and restruction of exception handling. The above modification is located in [Simulator_fp.h](../etpm/Simulator_fp.h) and [TcpServer.c](../etpm/TcpServer.c). To retain flexibility, we add the functionality of conditional compiling to support native Microsoft TPM simulator without Rats-TLS enhancement.

For details, refer to [modified etpm source code](../etpm).

## TSS software stack Side

>TPM Command Transmission Interface (TCTI) provides a standard interface to transmit / receive TPM command / response buffers. It is expected that any number of libraries implementing the TCTI API will be implemented as a way to abstract various platform specific IPC mechanisms. Currently this repository provides several TCTI implementations: libtss2-tcti-device, libtss2-tcti-tbs (for Windows), libtss2-tcti-swtpm and libtss2-tcti-mssim.

Notice our implementation is based on Microsoft TPM simulator, so we retrofit the `tcti-mssim.c/.h` to add Rats-TLS functionality. Meanwhile, we modify some wrapper functions in `io.c/.h` to support Rats-TLS enhancement. 
For details, refer to [modified tss2 source code](../tss2).
