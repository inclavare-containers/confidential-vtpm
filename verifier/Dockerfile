FROM ubuntu:20.04

LABEL maintainer="yishangzhang <Yishang.Zhang@linux.alibaba.com>"

SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    apt-get install -y libjson-c4 libjson-c-dev mariadb-server libmysqlclient-dev git make gcc wget && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /root/ibmtpm && \
    cd  /root/ibmtpm && \
    wget https://sourceforge.net/projects/ibmswtpm2/files/ibmtpm1682.tar.gz && \
    tar zxvf ibmtpm1682.tar.gz && \
    cd src && make install  

RUN mkdir /root/tpm2 && \
    cd /root/tpm2 && \
    wget https://versaweb.dl.sourceforge.net/project/ibmtpm20tss/ibmtss1.6.0.tar.gz && \
    tar zxvf ibmtss1.6.0.tar.gz

RUN for i in {1..5}; do \
        git clone https://github.com/kgoldman/acs.git /root/acs && \
        break; \
        sleep 5; \
    done

WORKDIR /usr/include 
RUN ln -s json-c json


WORKDIR /root/tpm2/utils
RUN make -f makefiletpm20 && \
    echo 'export CPATH=/root/tpm2/utils' >> /root/startup.sh&& \
    echo 'export LD_LIBRARY_PATH=/root/tpm2/utils:/root/tpm2/utils12' >> /root/startup.sh && \
    echo 'export TPM_DATA_DIR=/root/tpm2' >> /root/startup.sh && \
    echo 'export TPM_SERVER_TYPE=mssim' >> /root/startup.sh&& \
    echo 'export ACS_PORT=2323' >> /root/startup.sh && \   
    cat /root/startup.sh >> ~/.bashrc && \
    echo "tpm_server &" >>  /root/startup.sh && \
    echo "/root/tpm2/utils/powerup  &" >>  /root/startup.sh && \
    echo "/root/tpm2/utils/startup  &" >>  /root/startup.sh && \
    echo "service mysql start" >>  /root/startup.sh && \
    echo "/root/tpm2/acs/server -v -root ../utils/certificates/rootcerts.txt -imacert /root/tpm2/acs/imakey.der" >> /root/startup.sh
    
RUN source ~/.bashrc && chmod +x /root/startup.sh
COPY *patch* /root/acs/  

WORKDIR /root/acs
RUN git checkout abdcc9592ca5d12ae7d2146eed9f92c48e5e592b  && \
    git apply acs.patch.abdcc9592ca5d12ae7d2146eed9f92c48e5e592b && \
    mv /root/acs/acs /root/tpm2/acs && \
    cd /root/tpm2/acs && \
    make server && \
    service mysql start && \
    mysql -e  "CREATE DATABASE tpm2;" && \
    mysql -D tpm2 < dbinit.sql

CMD ["bash", "/root/startup.sh"]
