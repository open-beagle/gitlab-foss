# GitLab-Runtime

```bash
# debug amd64
docker run -it --rm \
-v /usr/local/share/.cache/yarn:/usr/local/share/.cache/yarn \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
-e USE_DB=false \
-e SKIP_STORAGE_VALIDATION=true \
-e NODE_OPTIONS=--max_old_space_size=3584 \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-amd64 \
bash -c '
bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems && \
bundle install --clean --deployment --without development test mysql aws kerberos --jobs 4 --retry 5 && \
yarn install --production --pure-lockfile && \
bundle exec rake gettext:compile && \
bundle exec rake gitlab:assets:compile
'

# debug arm64
docker run -it --rm \
-v /usr/local/share/.cache/yarn:/usr/local/share/.cache/yarn \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
-e RAILS_ENV=production \
-e NODE_ENV=production \
-e USE_DB=false \
-e SKIP_STORAGE_VALIDATION=true \
-e NODE_OPTIONS=--max_old_space_size=3584 \
registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-arm64 \
bash -c '
bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems && \
bundle install --clean --deployment --without development test mysql aws kerberos --jobs 4 --retry 5 && \
bundle exec rake gettext:compile
'

gem install nokogumbo -v '2.0.2' --source 'https://mirrors.tuna.tsinghua.edu.cn/rubygems/'
bundle install --deployment --without development test mysql aws kerberos --jobs 4 --retry 5

# amd64
docker build \
  --build-arg FROM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-amd64 \
  --build-arg AS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-amd64 \
  --file .beagle/gitlab-builder/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-amd64

# arm64
docker build \
  --build-arg FROM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-arm64 \
  --build-arg AS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-arm64 \
  --file .beagle/gitlab-builder/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-arm64

# ppc64le
docker build \
  --build-arg FROM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-runtime:v14.2.3-ppc64le \
  --build-arg AS_IMAGE=registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-ppc64le \
  --file .beagle/gitlab-builder/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-builder:v14.2.3-ppc64le
```
