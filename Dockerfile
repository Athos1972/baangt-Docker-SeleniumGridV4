FROM ubuntu:18.04

MAINTAINER Bernhard Buhl <buhl@buhl-consulting.com.cy>

RUN echo "Europe/Rome" > /etc/timezone

RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends tzdata

RUN dpkg-reconfigure -f noninteractive tzdata

# Install packages
RUN apt-get update -q && \
	export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository universe && \
    apt-get update -q && \
    apt-get remove -y python3.6 && \
    apt-get install -y --no-install-recommends wget curl rsync netcat mg vim bzip2 zip unzip && \
    apt-get install -y --no-install-recommends libx11-6 libxcb1 libxau6 jq python3-setuptools python3-tk && \
    apt-get install -y --no-install-recommends lxde tightvncserver xvfb dbus-x11 x11-utils && \
    apt-get install -y --no-install-recommends xfonts-base xfonts-75dpi xfonts-100dpi && \
    apt-get install -y --no-install-recommends python-pip python3.7-dev python-qt4 python3-pip tk-dev && \
    apt-get install -y --no-install-recommends libssl-dev git jq firefox unzip && \
    apt-get install -y --no-install-recommends default-jre && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install && \
    rm google-chrome-stable_current_amd64.deb && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Baangt
RUN git clone -b master https://gogs.earthsquad.global/athos/baangt --single-branch && \
    pip3 install -r baangt/requirements.txt && \
    rm -rf baangt/browserDrivers && \
    mkdir baangt/browserDrivers && \
    cd baangt/browserDrivers && \
    wget http://selenium-release.storage.googleapis.com/4.0-alpha5/selenium-server-4.0.0-alpha-5.jar && \
    cd ../..

WORKDIR /root/

# VNC-Server 
RUN mkdir -p /root/.vnc
COPY xstartup /root/.vnc/
RUN chmod a+x /root/.vnc/xstartup
RUN touch /root/.vnc/passwd && \
    /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd" > /root/.vnc/passwd && \ 
    chmod 400 /root/.vnc/passwd && \
    chmod go-rwx /root/.vnc && \
    touch /root/.Xauthority

COPY start-vncserver.sh /root/
COPY baangt.sh /root/
COPY baangt.ini /baangt/
RUN chmod a+x /root/start-vncserver.sh && \
    chmod a+x /root/baangt.sh && \
    echo "mycontainer" > /etc/hostname && \
    echo "127.0.0.1	localhost" > /etc/hosts && \
    echo "127.0.0.1	mycontainer" >> /etc/hosts

WORKDIR /baangt/
RUN python3 baangt.py --reloadDrivers=True

EXPOSE 5901
ENV USER root
CMD [ "/root/start-vncserver.sh" ]
