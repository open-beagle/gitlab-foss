# GitLab

```bash
# amd64
docker build \
  --no-cache \
  --build-arg GIT_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-git:v14.2.3-amd64 \
  --build-arg PYTHON_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-python:3.8.9-amd64 \
  --build-arg RAILS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-amd64 \
  --build-arg GITLAB_LOGGER_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-logger:v1.1.0-amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-sidekiq:v14.2.3-amd64 \
  --file ./.beagle/gitlab-sidekiq/Dockerfile ./.beagle/gitlab-sidekiq/

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-sidekiq:v14.2.3-amd64

# arm64
docker build \
  --no-cache \
  --build-arg GIT_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-git:v14.2.3-arm64 \
  --build-arg PYTHON_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-python:3.8.9-arm64 \
  --build-arg RAILS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-arm64 \
  --build-arg GITLAB_LOGGER_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-logger:v1.1.0-arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-sidekiq:v14.2.3-arm64 \
  --file ./.beagle/gitlab-sidekiq/Dockerfile ./.beagle/gitlab-sidekiq/

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-sidekiq:v14.2.3-arm64

# ppc64le
docker build \
  --no-cache \
  --build-arg GIT_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-git:v14.2.3-ppc64le \
  --build-arg PYTHON_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-python:3.8.9-ppc64le \
  --build-arg RAILS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-rails:v14.2.3-ppc64le \
  --build-arg GITLAB_LOGGER_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-logger:v1.1.0-ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod/gitlab-sidekiq:v14.2.3-ppc64le \
  --file ./.beagle/gitlab-sidekiq/Dockerfile ./.beagle/gitlab-sidekiq/

docker push registry.cn-qingdao.aliyuncs.com/wod/gitlab-sidekiq:v14.2.3-ppc64le
```
