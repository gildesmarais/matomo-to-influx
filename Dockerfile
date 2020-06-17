FROM ruby:2.6-stretch

RUN mkdir /app
WORKDIR /app

RUN apt-get update -qqy && apt-get -qqyy install --no-install-recommends \
    cron \
    && rm -rf /var/lib/apt/lists/* \
    && touch /var/log/cron.log

COPY Gemfile Gemfile.lock ./
RUN gem install --no-document bundler \
  && bundle config set without 'development test' \
  && bundle config --global frozen 1 \
  && bundle install --binstubs --retry=5 --jobs=7

COPY . .

RUN whenever -w

CMD printenv >> /etc/environment && /usr/sbin/cron -f
