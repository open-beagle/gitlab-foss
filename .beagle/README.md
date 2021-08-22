# GitLab

```bash
git remote add upstream git@gitlab.com:gitlab-org/gitlab-foss.git
git fetch upstream
git merge 14.1.3
```

## build

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

# gitlab
docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-base:v14.1.3-amd64 \
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
