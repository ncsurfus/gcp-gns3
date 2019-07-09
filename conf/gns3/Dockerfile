FROM ubuntu:18.04

# Install Dependencies, GNS3 Server, GNS3 IOU
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y software-properties-common wget docker.io --no-install-recommends \
    && add-apt-repository ppa:gns3/ppa -y \
    && apt-get install -y 'gns3-server=2.1.21~*' gns3-iou dynamips iouyap --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Add IOU License
WORKDIR /
RUN wget https://github.com/ncsurfus/goioulic/releases/download/v0.1.0/linux_amd64_goioulic
RUN chmod +x linux_amd64_goioulic
RUN echo "127.0.0.254 xml.cisco.com" >> /etc/hosts

# Add Config / Start scripts
ADD ./start.sh /start.sh
ADD ./config.ini /config.ini
RUN chmod +x /start.sh

# Create Data Directory
WORKDIR /data
VOLUME ["/data"]

ENTRYPOINT [ "/start.sh" ]
