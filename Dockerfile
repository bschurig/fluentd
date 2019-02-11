FROM debian:stretch-slim

ARG DEBIAN_FRONTEND=noninteractive

COPY Gemfile /Gemfile

RUN BUILD_DEPS="make gcc g++ libc6-dev ruby-dev libffi-dev build-essential libgeoip-dev libmaxminddb-dev" \
    && apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_DEPS \
    ca-certificates \
    libjemalloc1 \
    ruby \
    && echo 'gem: --no-document' >> /etc/gemrc \
    && /usr/bin/gem install --file Gemfile \
    && apt-get purge -y --auto-remove \
    -o APT::AutoRemove::RecommendsImportant=false \
    $BUILD_DEPS \
    && apt-get clean -y \
    && rm -rf \
    /var/cache/debconf/* \
    /var/lib/apt/lists/* \
    /var/log/* \
    /tmp/* \
    /var/tmp/* \
    && ulimit -n 65536

COPY fluent.conf /etc/fluent/fluent.conf
COPY scripts/run.sh /run.sh

EXPOSE 80

ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.1

ENTRYPOINT ["/run.sh"]