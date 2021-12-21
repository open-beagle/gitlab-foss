ARG GIT_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-git:v14.2.3-amd64"
ARG PYTHON_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-python:3.8.9-amd64"
ARG RAILS_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-amd64"
ARG GITLAB_LOGGER_IMAGE="registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-logger:v1.1.0-amd64"

FROM ${GIT_IMAGE} as git
FROM ${PYTHON_IMAGE} as python
FROM ${GITLAB_LOGGER_IMAGE} as gitlab-logger

FROM ${RAILS_IMAGE}

ARG DATADIR=/var/opt/gitlab
ARG CONFIG=/srv/gitlab/config
ARG DOCUTILS_VERSION="0.16"

COPY --from=python /usr/local/bin /usr/local/bin/
COPY --from=python /usr/local/lib /usr/local/lib/
ENV PYTHONPATH=/usr/local/lib/python3.8/site-packages
RUN ldconfig \
    && /usr/local/bin/pip3 install --compile docutils==${DOCUTILS_VERSION}
# END python install

# Pull in gitlab-logger
COPY --from=gitlab-logger /gitlab-logger /usr/local/bin/gitlab-logger

COPY --from=git /usr/bin/git /usr/bin/git-cvsserver /usr/bin/git-shell /usr/bin/

RUN ln -s /usr/bin/git /usr/bin/git-receive-pack && \
ln -s /usr/bin/git /usr/bin/git-upload-archive && \
ln -s /usr/bin/git /usr/bin/git-upload-pack

ARG GITLAB_USER=git

USER $GITLAB_USER:$GITLAB_USER

COPY scripts/ /scripts
COPY --chown=git configuration/ ${CONFIG}/

RUN cd /srv/gitlab && \
    mkdir -p public/uploads && chown ${GITLAB_USER}:${GITLAB_USER} public/uploads && \
    chmod 0700 public/uploads

ENV GITALY_FEATURE_DEFAULT_ON=1

CMD /scripts/process-wrapper

HEALTHCHECK --interval=30s --timeout=30s --retries=5 \
CMD /scripts/healthcheck
