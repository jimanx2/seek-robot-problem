FROM ruby:alpine

ARG APP_ENV=development

COPY ./app /app

WORKDIR /app