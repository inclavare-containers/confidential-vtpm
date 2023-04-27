# Build Image or Download Image
docker build -f etpm/etpm-Dockerfile -t docker4ctf/etpm_container:etpm_v0.2 .
docker build -f tss2/tss2-Dockerfile -t docker4ctf/etpm_container:tss2_v0.2 .