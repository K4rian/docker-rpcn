FROM rust:alpine3.20 AS builder

WORKDIR /tmp/rpcn

RUN apk update \
    && apk -U add --no-cache \
        build-base \
        git \
        openssl \
        openssl-dev \
    && mkdir -p /server/lib \
    && git clone "https://github.com/RipleyTom/rpcn.git" /tmp/rpcn/ \
    && OPENSSL_NO_VENDOR=1 RUSTFLAGS="-Ctarget-feature=-crt-static" cargo build --release --jobs 4 \
    && cp /tmp/rpcn/target/release/rpcn /server/rpcn \
    && cp /tmp/rpcn/*.cfg /server/ \
    && cp /server/rpcn.cfg /server/rpcn.cfg.default \
    && chmod +x /server/rpcn \
    && cp /usr/lib/libgcc_s.so.1 /server/lib/libgcc_s.so.1 \
    && cd /server \
    && openssl req -newkey rsa:4096 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem -subj '/CN=localhost' \
    && openssl ecparam -name secp224k1 -genkey -noout -out ticket_private.pem \
    && openssl ec -in ticket_private.pem -pubout -out ticket_public.pem \
    && rm -R /tmp/rpcn

FROM alpine:3.20

ENV USERNAME=rpcn
ENV USERHOME=/home/$USERNAME

ENV RPCN_HOST="0.0.0.0"
ENV RPCN_PORT=31313
ENV RPCN_HOSTV6=::
ENV RPCN_CREATEMISSING="true"
ENV RPCN_LOGVERBOSITY="Info"
ENV RPCN_EMAILVALIDATION="false"
ENV RPCN_EMAILHOST=""
ENV RPCN_EMAILLOGIN=""
ENV RPCN_EMAILPASSWORD=""
ENV RPCN_SIGNTICKETS="false"
ENV RPCN_SIGNTICKETSDIGEST="SHA224"
ENV RPCN_ENABLESTATSERVER="false"
ENV RPCN_STATSERVERHOST="0.0.0.0"
ENV RPCN_STATSERVERPORT=31314
ENV RPCN_STATSERVERCACHELIFE=1
ENV RPCN_ADMINLIST=""

RUN apk update \
    && apk -U add --no-cache \
        bash \
    && adduser --disabled-password $USERNAME \
    && rm -rf /tmp/* /var/tmp/*

COPY --from=builder --chown=$USERNAME /server $USERHOME/
COPY --chown=$USERNAME ./container_files $USERHOME/

USER $USERNAME
WORKDIR $USERHOME

RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]