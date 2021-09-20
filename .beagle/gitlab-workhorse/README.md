# GitLab

```bash
# gitlab-workhorse: build arch
docker run -it --rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e CURDIR=/go/src/gitlab.com/gitlab-org/gitlab \
-e GOPROXY=https://goproxy.cn \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.16.7-buster \
bash -c '
rm -rf .buildx/linux && \
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
cp workhorse/gitlab-* .buildx/linux/ppc64le/ && \
strip .buildx/linux/amd64/*
'

# gitlab-workhorse: build arch
docker run -it --rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.16.7-buster-arm64 \
bash -c 'strip .buildx/linux/arm64/*'

# gitlab-workhorse: build arch
docker run -it --rm \
-v /go/pkg/:/go/pkg/ \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.16.7-buster-ppc64le \
bash -c 'strip .buildx/linux/ppc64le/*'

# amd64
docker build \
  --build-arg RUBY_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.4-amd64 \
  --build-arg GIT_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-git:v14.2.3-amd64 \
  --build-arg RAILS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-amd64 \
  --build-arg VERSION=v14.2.3 \
  --build-arg TARGETARCH=amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-amd64 \
  --file ./.beagle/gitlab-workhorse/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-amd64

# arm64
docker build \
  --build-arg RUBY_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.4-arm64 \
  --build-arg GIT_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-git:v14.2.3-arm64 \
  --build-arg RAILS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-arm64 \
  --build-arg VERSION=v14.2.3 \
  --build-arg TARGETARCH=arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-arm64 \
  --file ./.beagle/gitlab-workhorse/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-arm64

# ppc64le
docker build \
  --build-arg RUBY_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.4-ppc64le \
  --build-arg GIT_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-git:v14.2.3-ppc64le \
  --build-arg RAILS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-ppc64le \
  --build-arg VERSION=v14.2.3 \
  --build-arg TARGETARCH=ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-ppc64le \
  --file ./.beagle/gitlab-workhorse/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-workhorse:v14.2.3-ppc64le
```
