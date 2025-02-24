FROM ruby:3.4-alpine

ARG APP_ENV=development

COPY app /srv/app

WORKDIR /srv/app

ENV RUBYLIB=/srv/app/lib
ENV BUNDLE_APP_CONFIG=/srv/app/.bundle
ENV BUNDLE_PATH=/srv/app/vendor/bundle

RUN bundle install --local && \
    chown -R 1000:1000 /srv/app/vendor/bundle

USER 1000

VOLUME ["/srv/app/vendor/bundle"]