ARG BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-amd64

FROM $BASE

ARG VERSION=14.1.3

RUN set -ex \
 && wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg  | apt-key add - \
 && echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list \
 && set -ex \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  nodejs yarn build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libre2-dev \
  libreadline-dev libncurses5-dev libffi-dev curl openssh-server libxml2-dev libxslt-dev \
  libcurl4-openssl-dev libicu-dev logrotate rsync pkg-config cmake runit-systemd


COPY Gemfile Gemfile.lock package.json yarn.lock /data/gitlab/
COPY vendor /data/gitlab/vendor
COPY scripts /data/gitlab/scripts

RUN cd /data/gitlab && \
bundle install -j"$(nproc)" --deployment --without development test mysql aws
