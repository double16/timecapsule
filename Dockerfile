FROM alpine:3.8

ARG SOURCE_COMMIT
ARG DOCKERFILE_PATH
ARG SOURCE_TYPE

ENV LANG=en_US.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=en_US.UTF-8 VERSION=3.1.11

RUN apk add --no-cache avahi build-base curl db-dev libgcrypt libgcrypt-dev file dbus afpfs-ng \
  && curl --fail --location https://downloads.sourceforge.net/project/netatalk/netatalk/${VERSION}/netatalk-${VERSION}.tar.gz | tar xzf - \
  && cd netatalk-${VERSION} \
  && ./configure --prefix= --enable-dbus --disable-ldap --enable-quota --enable-pgp-uam \
  && make \
  && make test \
  && make install \
  && cd - && rm -rf netatalk-${VERSION} \
  && apk del build-base libgcrypt-dev \
  && addgroup -g 1000 timecapsule \
  && adduser -u 1000 -G timecapsule -D timecapsule \
  && echo "timecapsule:timecapsule" | chpasswd

VOLUME [ "/backup" ]
EXPOSE 548

COPY etc/afp.conf /etc/
ADD etc/avahi/services/afpd.service /etc/avahi/services/afpd.service

COPY start.sh healthcheck.sh /
RUN chmod u+x /*.sh

CMD ["/start.sh"]

# Can't find package for mount_afp in Alpine Linux, afpgetstats isn't working
#HEALTHCHECK CMD /healthcheck.sh || exit 1
HEALTHCHECK CMD nc -zv localhost 548 || exit 1

LABEL maintainer="Patrick Double <pat@patdouble.com>" \
      org.label-schema.docker.dockerfile="$DOCKERFILE_PATH/Dockerfile" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.name="Supports Apple Time Machine backup by using netatalk ${VERSION} to look like a Time Capsule(tm)" \
      org.label-schema.url="https://github.com/double16/timecapsule" \
      org.label-schema.vendor="https://github.com/double16" \
      org.label-schema.vcs-ref="$SOURCE_COMMIT" \
      org.label-schema.vcs-type="$SOURCE_TYPE" \
      org.label-schema.vcs-url="https://github.com/double16/timecapsule.git" \
      org.label-schema.vendor="https://github.com/double16"
