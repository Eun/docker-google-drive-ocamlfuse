FROM ubuntu:xenial
MAINTAINER Eun <eun@su.am>

ENV DRIVE_PATH="/mnt/gdrive"

RUN echo "deb http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main" >> /etc/apt/sources.list \
 && echo "deb-src http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F639B041 \
 && apt-get update \
 && apt-get install -yy google-drive-ocamlfuse fuse bash \
 && apt-get clean all \
 && echo "user_allow_other" >> /etc/fuse.conf \
 && rm /var/log/apt/* /var/log/alternatives.log /var/log/bootstrap.log /var/log/dpkg.log

ADD docker-entrypoint.sh /bin/docker-entrypoint.sh

CMD	["chmod","+x","/bin/docker-entrypoint.sh"]
CMD	["/bin/bash", "/bin/docker-entrypoint.sh"]
