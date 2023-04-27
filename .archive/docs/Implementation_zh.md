## 关于代码

本项目基于[Microsoft TPM Simulator](https://github.com/microsoft/ms-tpm-20-ref)、[Occlum](https://github.com/occlum/occlum)、[Rats-TLS](https://github.com/inclavare-containers/rats-tls)和由tpm2-software社区提供的[tpm2-tss](https://github.com/tpm2-software/tpm2-tss)、[tpm2-abrmd](https://github.com/tpm2-software/tpm2-tss)、[tpm2-tools](https://github.com/tpm2-software/tpm2-tss)组成的 "tpm2三件套 "来实现。这些项目是用C语言实现的。它们的描述如下（摘自其文档）。

>微软TPM模拟器。这是[TPM 2.0规范]（https://trustedcomputinggroup.org/tpm-library-specification）的官方TCG参考实现。
>Occlum是一个内存安全的多进程库操作系统（LibOS），用于Intel SGX。
>Rats-TLS：一个支持异构硬件可执行环境的相互传输层安全协议。
>tpm2-tss。这个资源库包含实现TCG TPM2软件栈（TSS）的源代码。
>tpm2-abrmd。这是一个系统守护程序，实现了TCG TPM2访问代理（TAB）和资源管理器（RM）规范。
>tpm2-tools: 基于tpm2-tss的可信平台模块（TPM2.0）工具的源代码库。

## TPM Simulator侧

在目前的设计中，etpm的职责是提供加密、验证和其他安全攸关服务。 如上所述，Occlum和Rats-TLS分别保护存储和通信的安全。Occlum LibOS设计了一个有效的加密文件系统来保护eTPM的存储。我们可以在Occlum支持的SGX飞地中运行未经修改的vTPM。Rats-TLS利用远程验证的机制来保证通信的安全性。

与Socket编程不同，Rats-TLS使用句柄作为双方的UUID。我们改造了处理平台命令和TPM命令的入口函数，如`PlatformServer`、`PlatformSvcRoutine`、`RegularCommandService`，以及负责通信的封装函数，如`ReadBytes`、`WriteBytes`、`WriteUINT32`、`ReadUINT32`、`ReadVarBytes`和`WriteVarBytes`。主要贡献是使用Rats-TLS句柄替换了套接字，并重构了异常处理逻辑。上述修改位于[Simulator_fp.h](./etpm/Simulator_fp.h)和[TcpServer.c](./etpm/TcpServer.c)。为了保持灵活性，我们增加了条件编译的功能，以支持没有Rats-TLS增强的原生微软TPM模拟器。

详情请参考[修改后的etpm源代码](../etpm)。

## TSS软件栈侧

>TPM命令传输接口（TCTI）提供了一个标准接口来传输/接收TPM命令/响应缓冲区。 预计任何数量的实现TCTI API的库将被实现，作为抽象各种平台特定IPC机制的一种方式。 目前这个库提供了几个TCTI实现：libtss2-tcti-device、libtss2-tcti-tbs（用于Windows）、libtss2-tcti-swtpm和libtss2-tcti-mssim。

注意，我们的实现是基于微软TPM模拟器的，所以我们改造了`tcti-mssim.c/.h`以增加Rats-TLS功能。同时，我们修改了`io.c/.h`中的一些封装函数以支持Rats-TLS的增强。

详情请参考[修改后的tss2源代码](./tss2)。
