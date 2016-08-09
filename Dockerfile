FROM alpine:3.4
MAINTAINER Patrick Double <pat@patdouble.com>

ENV LANG=en_US.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US.UTF-8 VERSION=3.1.9

ADD 2nd-0001-afpd-cannot-build-when-ldap-is-not-defined.patch .
RUN apk add --no-cache avahi build-base curl db-dev file dbus \
  && curl http://heanet.dl.sourceforge.net/project/netatalk/netatalk/${VERSION}/netatalk-${VERSION}.tar.gz | tar xzf - \
  && cd netatalk-${VERSION} && patch -p1 < ../2nd-0001-afpd-cannot-build-when-ldap-is-not-defined.patch \
  && ./configure --prefix= --enable-dbus --disable-ldap \
  && make \
  && make test \
  && make install \
  && cd - && rm -rf netatalk-${VERSION} \
  && apk del build-base db-dev

RUN addgroup -g 1000 timecapsule && adduser -u 1000 -G timecapsule timecapsule && echo "timecapsule:timecapsule" | chpasswd || true

VOLUME /log
VOLUME /backup
EXPOSE 548

COPY etc/afp.conf /etc/
ADD etc/avahi/services/afpd.service /etc/avahi/services/afpd.service

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

CMD ["/start.sh"]

