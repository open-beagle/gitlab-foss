ARG FROM_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-amd64"
ARG PG_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-postgresql:13.2-amd64"
ARG GM_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-graphicsmagick:1.3.36-amd64"
ARG AS_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-amd64"

FROM ${AS_IMAGE} as assets
FROM ${PG_IMAGE} as pg_image
FROM ${GM_IMAGE} as graphicsmagick_image
FROM ${FROM_IMAGE}

ARG BUILD_DIR=/tmp/build
ARG DATADIR=/var/opt/gitlab
ARG GITLAB_USER=git
ARG COMPILE_ASSETS_ENV="RAILS_ENV=production NODE_ENV=production USE_DB=false SKIP_STORAGE_VALIDATION=true NODE_OPTIONS=--max_old_space_size=3584"

# Include postgres dev tools
COPY --from=pg_image /usr/local/psql/bin/ /usr/bin/
COPY --from=pg_image /usr/local/psql/lib/ /usr/lib/
COPY --from=pg_image /usr/local/psql/include/ /usr/include/
COPY --from=pg_image /usr/local/psql/share/ /usr/share/

# Include GraphicsMagick (bin,include,lib,share)
COPY --from=graphicsmagick_image /usr/local/ /usr/local/

# create gitlab user
RUN adduser --disabled-password --gecos 'GitLab' ${GITLAB_USER}

# $DATADIR is the main mountpoint for gitlab data volume
RUN mkdir ${DATADIR} && \
    cd ${DATADIR} && \
    mkdir data repo config && \
    chown -R ${GITLAB_USER}:${GITLAB_USER} ${DATADIR}

# Download GitLab
ARG CACHE_BUSTER=false
COPY --chown=git . /srv/gitlab/

# Configure GitLab
RUN cd /srv/gitlab && \
    sudo -u ${GITLAB_USER} -H mkdir ${DATADIR}/.upgrade-status && \
    sudo -u ${GITLAB_USER} -H echo 'gitlab-cloud-native-image' > INSTALLATION_TYPE && \
    sudo -u ${GITLAB_USER} -H cp config/gitlab.yml.example config/gitlab.yml && \
    sudo -u ${GITLAB_USER} -H cp config/resque.yml.example config/resque.yml && \
    sudo -u ${GITLAB_USER} -H cp config/secrets.yml.example config/secrets.yml && \
    sudo -u ${GITLAB_USER} -H cp config/database.yml.postgresql config/database.yml && \
    sed --in-place "/host: localhost/d" config/gitlab.yml && \
    sed --in-place "/port: 80/d" config/gitlab.yml && \
    sed --in-place "s/# user:.*/user: ${GITLAB_USER}/" config/gitlab.yml && \
    sed --in-place "s:/home/git/repositories:${DATADIR}/repo:" config/gitlab.yml

# Install gems
RUN cd /srv/gitlab && \
    sudo -u git -H bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems && \
    sudo -u git -H bundle install --clean --deployment --without development test mysql aws kerberos --jobs 4 --retry 5

# Install node dependencies
RUN cd /srv/gitlab && \
    sudo -u ${GITLAB_USER} -H $COMPILE_ASSETS_ENV yarn install --production --pure-lockfile

# compile GetText PO files
RUN cd /srv/gitlab && \
    sudo -u ${GITLAB_USER} -H $COMPILE_ASSETS_ENV bundle exec rake gettext:compile

# compile assets
RUN cd /srv/gitlab && \
    sudo -u ${GITLAB_USER} -H $COMPILE_ASSETS_ENV bundle exec rake gitlab:assets:compile

COPY .beagle/gitlab-builder/build-scripts/ /build-scripts

# Clean up
RUN cd /srv/gitlab && \
    rm -rf node_modules/ tmp/ spec/ ee/spec/ .beagle .buildx && \
    /build-scripts/cleanup-gems

# Set the path that bootsnap will use for cache
ENV BOOTSNAP_CACHE_DIR=/srv/gitlab/bootsnap
# Generate bootsnap cache
RUN echo "Generating bootsnap cache"; \
    cd /srv/gitlab && \
    sudo -u ${GITLAB_USER} mkdir ${BOOTSNAP_CACHE_DIR} && \
    sudo -u ${GITLAB_USER} -H $COMPILE_ASSETS_ENV ENABLE_BOOTSNAP=1 BOOTSNAP_CACHE_DIR=${BOOTSNAP_CACHE_DIR} \
         busybox time bin/rake about 2>/dev/null && \
    du -hs ${BOOTSNAP_CACHE_DIR} ;
# exit code of this command will be that of `du`

# install assets from assets container (see ARG ASSETS_IMAGE at top)
COPY --chown=git --from=assets /srv/gitlab/public/assets/ /srv/gitlab/public/assets/

# remove uncompressed maps as per #2062
RUN find /srv/gitlab/public/assets/webpack -name '*.map' -type f -print -delete
