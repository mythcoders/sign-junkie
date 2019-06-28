FROM ruby:2.5.1-alpine

ENV APP_HOME /app

RUN apk --no-cache add nodejs postgresql-client imagemagick tzdata

RUN gem install bundler -v 1.17.3

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock $APP_HOME/

# Install build dependencies - required for gems with native dependencies
RUN apk add --no-cache --virtual build-deps build-base postgresql-dev && \
  bundle install && \
  apk del build-deps

ADD . $APP_HOME

CMD ["puma"]
