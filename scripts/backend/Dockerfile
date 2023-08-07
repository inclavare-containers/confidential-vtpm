FROM occlum/occlum:latest-dev-e2f7e61-ubuntu20.04 

LABEL maintainer="Yishang.Zhang@linux.alibaba.com"

RUN apt update -y && \
    apt install -y  dh-autoreconf libssl-dev libtasn1-6-dev pkg-config \
    net-tools iproute2 libjson-glib-dev libgnutls28-dev expect \
    gawk socat make

COPY libtpms /root/tpm/libtpms
COPY swtpm /root/tpm/swtpm

WORKDIR /root/tpm/libtpms
RUN ./autogen.sh --with-openssl --prefix=/usr --with-tpm2 && \
    make -j && make install

WORKDIR /root/tpm/swtpm
RUN ./autogen.sh --with-openssl --prefix=/usr --without-seccomp --with-tpm2 && \
    make -j && make install && ldconfig 

WORKDIR /root
COPY swtpm.yaml /root/swtpm.yaml 
COPY start.sh /root/start.sh
RUN rm -rf  /root/tpm/ && \
    chmod +711 start.sh && \
    mkdir -p /tmp/tpmstate &&  \
    occlum new occlum_swtpm && \
    cd occlum_swtpm && \
    rm -rf image && \
    copy_bom -f ../swtpm.yaml --root image --include-dir /opt/occlum/etc/template && \
    occlum build 

WORKDIR /root/occlum_swtpm
