# GitLab-Runtime

```bash
# debug
docker run -it --rm \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.2-amd64 \
bash

# amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.2-amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-amd64 \
  --file .beagle/gitlab-runtime/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-amd64

# arm64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.2-arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-arm64 \
  --file .beagle/gitlab-runtime/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-arm64

# ppc64le
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-ruby:2.7.2-ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-ppc64le \
  --file .beagle/gitlab-runtime/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-ppc64le
```
