# GitLab

```bash
git remote add upstream git@gitlab.com:gitlab-org/gitlab-foss.git
git fetch upstream
git merge 14.1.3
```

## build: debug

<https://docs.gitlab.com/ce/install/installation.html>

```bash
# gitlab-workhorse
docker run -it --rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e CURDIR=/go/src/gitlab.com/gitlab-org/gitlab \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.16.6-alpine \
make -C workhorse install

# gitlab-foss-amd64
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-amd64 \
bash -c '
rm -rf .buildx node_modules vendor/bundle && \
cp -r /data/gitlab/node_modules /go/src/gitlab.com/gitlab-org/gitlab/node_modules && \
cp -r /data/gitlab/vendor/bundle /go/src/gitlab.com/gitlab-org/gitlab/vendor/bundle && \
bash .beagle/gitlab/patch.sh && \
bundle install -j"$(nproc)" --deployment --without development test mysql aws && \
yarn install --production --pure-lockfile && \
cp ./config/resque.yml.example ./config/resque.yml && \
cp ./config/gitlab.yml.example ./config/gitlab.yml && \
cp ./config/database.yml.postgresql ./config/database.yml && \
bundle exec rake gitlab:assets:compile USE_DB=false SKIP_STORAGE_VALIDATION=true NODE_OPTIONS="--max-old-space-size=4096"
'

# gitlab-foss-arm64
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-arm64 \
bash -c '
rm -rf .buildx node_modules vendor/bundle && \
cp -r /data/gitlab/vendor/bundle /go/src/gitlab.com/gitlab-org/gitlab/vendor/bundle && \
bash .beagle/gitlab/patch.sh && \
bundle install -j"$(nproc)" --deployment --without development test mysql aws
'

# gitlab
docker pull registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.1.3-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.1.3-amd64 \
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
mkdir -p .buildx/gitlab-shell && \
cp -r /gitlab-org/gitlab-shell/* .buildx/gitlab-shell/ 
'

# gitlab-pages-amd64
docker pull registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-pages:v1.41.0-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-pages:v1.41.0-amd64 \
ash -c '
mkdir -p .buildx/gitlab-pages && \
cp -a /usr/local/bin/gitlab-pages .buildx/gitlab-pages/gitlab-pages
'

# gitlab-gitaly-amd64
docker pull registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-gitaly:v14.1.3-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-gitaly:v14.1.3-amd64 \
ash -c '
mkdir -p .buildx/gitlab-gitaly && \
cp -r /gitlab-org/gitaly/* .buildx/gitlab-gitaly/
'

# gitlab-workhorse-amd64
docker run -it --rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e CURDIR=/go/src/gitlab.com/gitlab-org/gitlab \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.16.6-alpine \
bash -c '
mkdir -p .buildx/gitlab-workhorse && \
make -C workhorse install && \
cp workhorse/gitlab-* .buildx/gitlab-workhorse/
'

# gitlab-foss-amd64
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-amd64 \
bash -c '
rm -rf .buildx node_modules vendor/bundle && \
cp -r /data/gitlab/node_modules /go/src/gitlab.com/gitlab-org/gitlab/node_modules && \
cp -r /data/gitlab/vendor/bundle /go/src/gitlab.com/gitlab-org/gitlab/vendor/bundle && \
bash .beagle/gitlab/patch.sh && \
bundle install -j"$(nproc)" --deployment --without development test mysql aws && \
yarn install --production --pure-lockfile && \
cp ./config/resque.yml.example ./config/resque.yml && \
cp ./config/gitlab.yml.example ./config/gitlab.yml && \
cp ./config/database.yml.postgresql ./config/database.yml && \
bundle exec rake gitlab:assets:compile USE_DB=false SKIP_STORAGE_VALIDATION=true NODE_OPTIONS="--max-old-space-size=4096"
'

# gitlab-foss-arm64
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-arm64 \
bash -c '
rm -rf .buildx node_modules vendor/bundle && \
cp -r /data/gitlab/vendor/bundle /go/src/gitlab.com/gitlab-org/gitlab/vendor/bundle && \
bash .beagle/gitlab/patch.sh && \
bundle install -j"$(nproc)" --deployment --without development test mysql aws
'

# gitlab
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-base:v14.1.3-amd64 \
bash

# gitlab
docker pull registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.1.3-amd64 && \
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.1.3-amd64 \
bash

# amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-base:v14.1.3-amd64 \
  --build-arg VERSION=v14.1.3 \
  --build-arg TARGETARCH=amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.1.3-amd64 \
  --file ./.beagle/gitlab/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab:14.1.3-amd64

# arm64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-base:v14.1.3-arm64 \
  --build-arg VERSION=v14.1.3 \
  --build-arg TARGETARCH=arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab:v14.1.3-arm64 \
  --file ./.beagle/gitlab/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab:14.1.3-arm64
```
