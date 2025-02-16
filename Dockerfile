FROM ruby:3.4-alpine

ARG APP_ENV=development

COPY app /srv/app

WORKDIR /srv/app

ENV RUBYLIB=/srv/app/lib
ENV BUNDLE_APP_CONFIG=/srv/app/.bundle
ENV BUNDLE_PATH=/src/app/vendor/bundle

RUN bundle install --local --deployment
VOLUME ["/srv/app/vendor/bundle"]