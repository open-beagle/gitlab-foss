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
-e CURDIR=/go/src/gitlab.com/gitlab-org/gitlab \
registry.cn-qingdao.aliyuncs.com/wod/ruby:2.7.4-bullseye \
bash

apt update -y 
apt install -y nodejs yarn cmake

apt install -y supervisor logrotate locales curl \
      nginx openssh-server redis-tools \
      python3 python3-docutils gettext-base graphicsmagick \
      libpq5 zlib1g libyaml-0-2 libssl1.1 \
      libgdbm6 libreadline8 libncurses5 libffi7 \
      libxml2 libxslt1.1 libcurl4 libre2-dev tzdata unzip libimage-exiftool-perl \
      libmagic1 

bundle install -j"$(nproc)" --deployment --without development test mysql aws

yarn install --production --pure-lockfile

bundle exec rake gitlab:assets:compile USE_DB=false SKIP_STORAGE_VALIDATION=true NODE_OPTIONS="--max-old-space-size=4096"

yarn
bundle exec rake gitlab:assets:compile USE_DB=false SKIP_STORAGE_VALIDATION=true NODE_OPTIONS="--max-old-space-size=4096"

docker run -it --rm \
-v $PWD:/go/src/gitlab.com/gitlab-org/gitlab \
-w /go/src/gitlab.com/gitlab-org/gitlab \
node:12.22.5-bullseye \
bash

apt update -y 
apt install -y supervisor logrotate locales curl \
      nginx openssh-server redis-tools \
      ruby python3 python3-docutils gettext-base graphicsmagick \
      libpq5 zlib1g libyaml-0-2 libssl1.1 \
      libgdbm6 libreadline8 libncurses5 libffi7 \
      libxml2 libxslt1.1 libcurl4 libre2-dev tzdata unzip libimage-exiftool-perl \
      libmagic1 \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && locale-gen en_US.UTF-8 \
 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \
 && gem install --no-document bundler -v 2.1.4 \
 && rm -rf /var/lib/apt/lists/*
gem install bundler
bundle install
bundle exec rake gitlab:assets:compile USE_DB=false SKIP_STORAGE_VALIDATION=true NODE_OPTIONS="--max-old-space-size=4096"

# amd64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/ubuntu:20.04-amd64 \
  --build-arg VERSION=14.1.3 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/sameersbn-gitlab:14.1.3-amd64 \
  --file ./.beagle/Dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/sameersbn-gitlab:14.1.3-amd64

# arm64
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/ubuntu:20.04-arm64 \
  --build-arg VERSION=14.1.3 \
  --tag registry.cn-qingdao.aliyuncs.com/wod/sameersbn-gitlab:14.1.3-arm64 \
  --file ./.beagle/Dockerfile .

docker push registry.cn-qingdao.aliyuncs.com/wod/sameersbn-gitlab:14.1.3-arm64
```
