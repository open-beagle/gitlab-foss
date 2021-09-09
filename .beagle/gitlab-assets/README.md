# GitLab-Runtime

```bash
# debug
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
cp config/gitlab.yml.example config/gitlab.yml && \
cp config/resque.yml.example config/resque.yml && \
cp config/secrets.yml.example config/secrets.yml && \
cp config/database.yml.postgresql config/database.yml && \
bundle config mirror.https://rubygems.org https://mirrors.tuna.tsinghua.edu.cn/rubygems && \
bundle install --clean --deployment --without development test mysql aws kerberos --jobs 4 --retry 5 && \
yarn install --production --pure-lockfile && \
bundle exec rake gettext:compile && \
bundle exec rake gitlab:assets:compile
'

# amd64
docker build \
  --build-arg FROM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod/alpine:3.13-amd64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-amd64 \
  --file .beagle/gitlab-assets/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-amd64

# arm64
docker build \
  --build-arg FROM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod/alpine:3.13-arm64 \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-arm64 \
  --file .beagle/gitlab-assets/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-arm64

# ppc64le
docker build \
  --build-arg FROM_IMAGE=registry.cn-qingdao.aliyuncs.com/wod/alpine:3.13-ppc64le \
  --tag registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-ppc64le \
  --file .beagle/gitlab-assets/dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod-arm/gitlab-assets:v14.2.3-ppc64le
```
