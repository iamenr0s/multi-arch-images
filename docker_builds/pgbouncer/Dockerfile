FROM alpine:3.18.4 AS build_stage

ARG PGBOUNCER_VERSION

WORKDIR /
RUN apk --update add python py-pip build-base automake libtool m4 autoconf libevent-dev openssl-dev c-ares-dev
RUN pip install docutils \
  && wget https://github.com/pgbouncer/pgbouncer/releases/download/pgbouncer_$(echo "$PGBOUNCER_VERSION"|sed 's/\./\_/g')/pgbouncer-${PGBOUNCER_VERSION}.tar.gz \
  && tar zxf pgbouncer-${PGBOUNCER_VERSION}.tar.gz && rm pgbouncer-${PGBOUNCER_VERSION}.tar.gz \
  && cd /pgbouncer-${PGBOUNCER_VERSION}/ \
  && ./configure --prefix=/pgbouncer \
  && make \
  && make install

WORKDIR /bin
RUN ln -s ../usr/bin/rst2man.py rst2man

FROM alpine:3.18.4

RUN apk --update add libevent openssl c-ares
WORKDIR /
COPY --from=build_stage /pgbouncer /pgbouncer
ADD entrypoint.sh ./

ENTRYPOINT ["./entrypoint.sh"]
