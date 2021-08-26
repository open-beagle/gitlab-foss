# GitLab-builder

```bash
# amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-amd64 \
  --file ./.beagle/builder/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-amd64

# arm64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-arm64 \
  --file ./.beagle/builder/arch.Dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-arm64

# ppc64le
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.1.3-ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-ppc64le \
  --file ./.beagle/builder/arch.Dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.1.3-ppc64le
```
