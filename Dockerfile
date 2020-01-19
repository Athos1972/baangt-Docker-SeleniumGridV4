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
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install && \
    rm google-chrome-stable_current_amd64.deb && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Baangt
RUN git clone https://gogs.earthsquad.global/athos/baangt && \
    pip3 install -r baangt/requirements.txt

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
COPY getdrivers.sh /root/
RUN chmod a+x /root/start-vncserver.sh && \
    chmod a+x /root/baangt.sh && \
    chmod a+x /root/getdrivers.sh && \
    /root/getdrivers.sh && \
    echo "mycontainer" > /etc/hostname && \
    echo "127.0.0.1	localhost" > /etc/hosts && \
    echo "127.0.0.1	mycontainer" >> /etc/hosts

EXPOSE 5901
ENV USER root
CMD [ "/root/start-vncserver.sh" ]
