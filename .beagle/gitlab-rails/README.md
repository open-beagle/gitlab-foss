# GitLab

```bash
# amd64
docker build \
  --build-arg BASE_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.4-amd64 \
  --build-arg BUILDER_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-amd64 \
  --build-arg PG_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-postgresql:13.2-amd64 \
  --build-arg GM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-graphicsmagick:1.3.36-amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-amd64 \
  --file ./.beagle/gitlab-rails/Dockerfile ./.beagle/gitlab-rails/

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-amd64

# arm64
docker build \
  --build-arg BASE_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.4-arm64 \
  --build-arg BUILDER_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-arm64 \
  --build-arg PG_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-postgresql:13.2-arm64 \
  --build-arg GM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-graphicsmagick:1.3.36-arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-arm64 \
  --file ./.beagle/gitlab-rails/Dockerfile ./.beagle/gitlab-rails/

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-arm64

# ppc64le
docker build \
  --build-arg BASE_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.4-ppc64le \
  --build-arg BUILDER_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-ppc64le \
  --build-arg PG_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-postgresql:13.2-ppc64le \
  --build-arg GM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-graphicsmagick:1.3.36-ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-ppc64le \
  --file ./.beagle/gitlab-rails/Dockerfile ./.beagle/gitlab-rails/

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-ppc64le
```
