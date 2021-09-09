# GitLab

```bash
git remote add upstream git@gitlab.com:gitlab-org/gitlab-foss.git
git fetch upstream
git merge v14.2.3
```

## build: debug

<https://docs.gitlab.com/ce/install/installation.html>

```bash
# gitlab-builder
docker build \
  --build-arg BASE_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.2-amd64 \
  --build-arg VERSION=v14.2.3 \
  --build-arg TARGETARCH=amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-amd64 \
  --file ./.beagle/base/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-amd64

# gitlab-workhorse: build arch
docker run -it --rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e CURDIR=/go/src/gitlab.com/gitlab-org/gitlab \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.16.7-buster \
bash -c '
mkdir -p .buildx/linux/amd64 && \
export GOARCH=amd64
make -C workhorse install && \
cp workhorse/gitlab-* .buildx/linux/amd64/ && \
mkdir -p .buildx/linux/arm64 && \
export GOARCH=arm64
make -C workhorse install && \
cp workhorse/gitlab-* .buildx/linux/arm64/ && \
mkdir -p .buildx/linux/ppc64le && \
export GOARCH=ppc64le
make -C workhorse install && \
cp workhorse/gitlab-* .buildx/linux/ppc64le/
'

# gitlab-workhorse: image amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.2-amd64 \
  --build-arg VERSION=v14.2.3 \
  --build-arg TARGETARCH=amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-amd64 \
  --file ./.beagle/base/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-amd64



# gitlab-foss-arm64
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-arm64 \
bash -c '
rm -rf .buildx node_modules vendor/bundle && \
cp -r /data/gitlab/vendor/bundle /go/src/gitlab.com/gitlab-org/gitlab/vendor/bundle && \
bash .beagle/gitlab/patch.sh && \
bundle install -j"$(nproc)" --deployment --without development test mysql aws
'

# gitlab-alpha
docker pull registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.2.3-alpha && \
docker run -it --rm \
--entrypoint bash \
registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.2.3-alpha

# gitlab
docker pull registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.2.3-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.2.3-amd64 \
bash

```

## build: image

```bash
# gitlab-shell-amd64
docker pull registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-shell:v13.19.1-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-shell:v13.19.1-amd64 \
ash -c '
rm -rf .buildx && \
mkdir -p .buildx/git/gitlab-shell && \
cp -r /gitlab-org/gitlab-shell/* .buildx/git/gitlab-shell/ 
'

# gitlab-pages-amd64
docker pull registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-pages:v1.41.0-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-pages:v1.41.0-amd64 \
ash -c '
mkdir -p .buildx/bin/ && \
cp -a /usr/local/bin/gitlab-pages .buildx/bin/
'

# gitlab-gitaly-amd64
docker pull registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-gitaly:v14.2.3-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-gitaly:v14.2.3-amd64 \
ash -c '
mkdir -p .buildx/git/gitaly && \
cp -r /gitlab-org/gitaly/* .buildx/git/gitaly/ && \
mv .buildx/git/gitaly/_build/bin/git-* .buildx/bin/ && \
mv .buildx/git/gitaly/_build/bin/git .buildx/bin/ && \
mv .buildx/git/gitaly/_build/bin/gitaly .buildx/bin/
'

# gitlab-workhorse-amd64
docker run -it --rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e CURDIR=/go/src/gitlab.com/gitlab-org/gitlab \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.16.6-buster \
bash -c '
mkdir -p .buildx/bin && \
make -C workhorse install && \
cp workhorse/gitlab-* .buildx/bin/
'

# gitlab-foss-amd64
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-amd64 \
bash -c '
rm -rf node_modules vendor/bundle && \
cp -r /data/gitlab/node_modules /go/src/gitlab.com/gitlab-org/gitlab/node_modules && \
cp -r /data/gitlab/vendor/bundle /go/src/gitlab.com/gitlab-org/gitlab/vendor/bundle && \
bash .beagle/gitlab/patch.sh && \
bundle install -j"$(nproc)" --deployment --without development test mysql aws && \
yarn install --production --pure-lockfile && \
cp ./config/resque.yml.example ./config/resque.yml && \
cp ./config/gitlab.yml.example ./config/gitlab.yml && \
cp ./config/database.yml.postgresql ./config/database.yml && \
bundle exec rake gitlab:assets:compile USE_DB=false SKIP_STORAGE_VALIDATION=true NODE_OPTIONS="--max-old-space-size=4096" && \
strip .buildx/bin/*
strip .buildx/git/gitlab-shell/bin/*
strip .buildx/git/gitaly/_build/bin/*
'

# gitlab-base-amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-amd64 \
  --build-arg VERSION=v14.2.3 \
  --build-arg TARGETARCH=amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-base:v14.2.3-amd64 \
  --file ./.beagle/base/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-base:v14.2.3-amd64

# gitlab-amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-base:v14.2.3-amd64 \
  --build-arg VERSION=v14.2.3 \
  --build-arg TARGETARCH=amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.2.3-alpha \
  --file ./.beagle/gitlab/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.2.3-alpha
```
