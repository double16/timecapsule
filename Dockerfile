FROM ubuntu:14.04.2
MAINTAINER Patrick Double <pat@patdouble.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -q update
RUN apt-get -qy --force-yes dist-upgrade

RUN apt-get install -qy --force-yes netatalk avahi-daemon

# apt clean
RUN apt-get clean &&\
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/*

RUN useradd timecapsule -p "timecapsule" -m && echo "timecapsule:timecapsule" | chpasswd 

VOLUME /log
VOLUME /backup
EXPOSE 548

RUN sed -i 's:/usr/bin/dbus:/bin/dbus:' /etc/init.d/dbus
COPY etc/netatalk/* /etc/netatalk/

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

CMD ["/start.sh"]

