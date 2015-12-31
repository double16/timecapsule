FROM debian:sid
MAINTAINER Patrick Double <pat@patdouble.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get -q update &&\
  apt-get -qy --force-yes dist-upgrade &&\
  apt-get install -qy --force-yes netatalk avahi-daemon &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/*

RUN useradd timecapsule -p "timecapsule" -m && echo "timecapsule:timecapsule" | chpasswd 

VOLUME /log
VOLUME /backup
EXPOSE 548

COPY etc/netatalk/* /etc/netatalk/
ADD etc/avahi/services/afpd.service /etc/avahi/services/afpd.service

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

CMD ["/start.sh"]

