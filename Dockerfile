FROM registry.gitlab.com/mythcoders/gaia:latest AS base

COPY Gemfile* $APP_HOME/
RUN apk add --no-cache --virtual build-deps build-base && \
  bundle install && \
  apk del build-deps

EXPOSE $APP_PORT

FROM base AS build
ADD . $APP_HOME/
CMD ["sh", "./scripts/app", "start"]
