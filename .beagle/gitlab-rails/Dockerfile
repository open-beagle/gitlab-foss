ARG BASE_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.4-amd64"
ARG BUILDER_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-amd64"
ARG PG_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-postgresql:13.2-amd64"
ARG GM_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-graphicsmagick:1.3.36-amd64"

FROM ${PG_IMAGE} as pg_image
FROM ${GM_IMAGE} as graphicsmagick_image
FROM ${BUILDER_IMAGE} as builder

# Final image
FROM ${BASE_IMAGE} 
ARG DATADIR=/var/opt/gitlab
ARG CONFIG=/srv/gitlab/config
ARG GITLAB_USER=git

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=866729
RUN mkdir -p /usr/share/man/man7 \
    && apt-get update \
    && apt-get install -q -y --no-install-recommends \
         libicu-dev libre2-dev tzdata xtail \
         libpng16-16 libtiff5 libturbojpeg0 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Include postgres client tools
COPY --from=pg_image /usr/local/psql/bin/pg_* /usr/bin/
COPY --from=pg_image /usr/local/psql/bin/psql /usr/bin/
COPY --from=pg_image /usr/local/psql/lib/libpq.so.5.13 /usr/lib/

RUN ln -s /usr/lib/libpq.so.5.13 /usr/lib/libpq.so.5 \
    && ln -s /usr/lib/libpq.so.5.13 /usr/lib/libpq.so

# Include GraphicsMagick (binary and license)
COPY --from=graphicsmagick_image /usr/local /usr/local

RUN buildDeps=' \
    libicu-dev \
    libffi-dev \
    libre2-dev \
    libedit-dev \
    libxml2-dev \
    sudo' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $buildDeps \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos 'GitLab' ${GITLAB_USER}

COPY --chown=git --from=builder /srv/gitlab /srv/gitlab
COPY --chown=git --from=builder /var/opt/gitlab /var/opt/gitlab

RUN mv /srv/gitlab/log /var/log/gitlab && \
    ln -s /var/log/gitlab /srv/gitlab/log && \
    cd /srv/gitlab && \
    chmod o-rwx config/database.yml && \
    chmod 0600 config/secrets.yml && \
    chmod -R u+rwX builds/ && \
    chmod -R u+rwX shared/artifacts/ && \
    chmod -R ug+rwX shared/pages/ && \
    chmod -R ug+rwX,o-rwx ${DATADIR}/repo && \
    chmod -R ug-s ${DATADIR}/repo && \
    find ${DATADIR}/repo -type d -print0 | sudo xargs -0 chmod g+s && \
    mkdir -p public/uploads && chown ${GITLAB_USER}:${GITLAB_USER} public/uploads && \
    chmod 0700 public/uploads && \
    mkdir /home/git/gitlab-shell && \
    chown git:git /home/git/gitlab-shell && \
    ln -s /srv/gitlab/GITLAB_SHELL_VERSION /home/git/gitlab-shell/VERSION

COPY scripts/ /scripts

RUN chown -R ${GITLAB_USER} /scripts

ENV RAILS_ENV=production \
    BOOTSNAP_CACHE_DIR=/srv/gitlab/bootsnap \
    EXECJS_RUNTIME=Disabled \
    CONFIG_TEMPLATE_DIRECTORY=${CONFIG} \
    UPGRADE_STATUS_DIR=${DATADIR}/.upgrade-status

VOLUME /var/opt/gitlab /var/log
