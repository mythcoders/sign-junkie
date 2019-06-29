FROM registry.gitlab.com/mythcoders/gaia:latest

COPY Gemfile Gemfile.lock $APP_HOME/

# Install build dependencies - required for gems with native dependencies
RUN apk add --no-cache --virtual build-deps build-base && \
  bundle install && \
  apk del build-deps

ADD . $APP_HOME

CMD ["puma"]
