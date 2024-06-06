FROM ruby:3.2.4-alpine

RUN apk add --update --virtual \
  runtime-deps \
  postgresql-client \
  build-base \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  yarn \
  libffi-dev \
  readline \
  build-base \
  postgresql-dev \
  sqlite-dev \
  libc-dev \
  linux-headers \
  readline-dev \
  file \
  imagemagick \
  git \
  tzdata \
	jpeg-dev \
  && rm -rf /var/cache/apk/*

WORKDIR /sfhelpdesk
COPY . /sfhelpdesk/

ENV BUNDLE_PATH /gems

RUN bundle install