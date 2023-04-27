# Background
The vTPM solution provides trusted computing capabilities for tenants. Based on trusted server hardware, the trust is extended from the host to the guest, creating a secure system based on hardware and virtual trust roots. While the fundamental softwares (e.g., operation system, hypervisor) are consolidating more and more functionalities with simultaneous inevitable vulnerabilities, these vulnerablities have opened an aisle of exploration for attacking the existing vTPM scheme.

Confidential computing is a new computing model that protects and isolates data in use by executing the computation process in a hardware-based Trusted Execution Environment (TEE). With the TEE support, security-critical applications can be protected from the unauthorized access from privileged operation system, hypervisor and even platform owner.

However, adopting the TEE directly is limited in cloud computing scenarios still. Some depend the trusted boot to obtain the trust originated from the hardware Root of Trust (HW-RoT), which makes this proposal be constrained by particular hardware, shrinking the scalability. Some lack the dynamic measurement capabilities which makes it impossible to extend and propagate the trust within the TEE guest system, and impossible to measure and verify loaded components, greatly reducing the trustworthiness of the TEE technology.

To meet the requirements of security and privacy, the vTPM architecture must be protected by the elegant hardware-software co-desgin based on the extant TEE.

# Architecture
Confidential vtpm currently consists of three components: TPM frontend, TPM backend and Verifier.

## TPM Frontend
The TPM Frontend is responsible for forwarding requests and responses between the host and the TPM Backend.
## TPM Backend
TPM Backend performs as a prevalent TPM simulator which follows the TPM specification.

## Verifier
The Verifier identifies the genuineness EKs/AKs which pertain to the corresponding TPM Backends.

# Workflow:
## Manufacturing Process
During the manufacturing process, the TPM is integrated into the system and the EK is generated. The EK is then signed by a trusted authority to establish its trust from RoT.

## Registration Process
During the registration process, the AK is generated based on the EK.

## Quote Verification Process
During the quote verification process, the host system requests a quote from the TPM. The TPM generates a quote that includes information about the system state. The quote is then sent to the Verifier, which checks the validity of the EK/AK and the quote. If it is valid, the Verifier sends a response back to notify the host system.
