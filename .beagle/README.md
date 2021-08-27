# GitLab

```bash
git remote add upstream git@gitlab.com:gitlab-org/gitlab-foss.git
git fetch upstream
git merge 14.1.3
```

## build

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
