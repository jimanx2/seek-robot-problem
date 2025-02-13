FROM ruby:alpine

ARG APP_ENV=development

COPY ./app /app

WORKDIR /app

RUN if ["${APP_ENV}" = "production"]; then \
    bundle config set deployment true && bundle install --local; \
fi

# VOLUME [ "/app/vendor" ]