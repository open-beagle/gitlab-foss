# GitLab-Runtime

```bash
# debug
docker run -it --rm \
registry.cn-qingdao.aliyuncs.com/wod/ruby:2.7.4-slim-bullseye-amd64 \
bash

# amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/ruby:2.7.4-slim-bullseye-amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-amd64 \
  --file .beagle/runtime/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-amd64

# arm64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/ruby:2.7.4-slim-bullseye-arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-arm64 \
  --file .beagle/runtime/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-arm64

# ppc64le
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/ruby:2.7.4-slim-bullseye-ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-ppc64le \
  --file .beagle/runtime/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-ppc64le
```
