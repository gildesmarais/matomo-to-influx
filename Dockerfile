FROM ruby:2.6-stretch

RUN mkdir /app
WORKDIR /app

RUN apt-get update -qqy && apt-get -qqyy install --no-install-recommends \
    cron
RUN rm -rf /var/lib/apt/lists/*

RUN touch /var/log/cron.log

COPY Gemfile Gemfile.lock ./
RUN gem install --no-document bundler
RUN bundle config --global frozen 1
RUN bundle install --binstubs --retry=5 --jobs=7 --without development test

COPY . .

RUN whenever -w

CMD printenv >> /etc/environment && /usr/sbin/cron -f
