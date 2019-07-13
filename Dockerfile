FROM registry.gitlab.com/mythcoders/gaia:latest AS base
COPY Gemfile Gemfile.lock $APP_HOME/
# Install build dependencies - required for gems with native dependencies
RUN apk add --no-cache --virtual build-deps build-base && \
  bundle install && \
  apk del build-deps
EXPOSE $PORT

 # Dev environment doesn't run this stage or beyond
FROM base AS build
ADD . $APP_HOME/
CMD ["sh", "-c", "bundle exec rails s -b 0.0.0.0 -p ${PORT}"]
