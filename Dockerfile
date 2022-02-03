FROM ghcr.io/mythcoders/gaia-ruby3:latest AS base

ENV APP_HOME=/opt/sign-junkie
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN apk add --no-cache --virtual build-deps build-base && \
  apk upgrade && apk add vips libxml2-dev libxslt-dev

RUN bundle install && apk del build-deps

COPY package.json yarn.lock $APP_HOME/
RUN yarn install --frozen-lockfile

EXPOSE 5000

FROM base AS build

ADD . $APP_HOME/

RUN ASSETS_PRECOMPILE=1 SECRET_KEY_BASE=1 NODE_ENV=production RAILS_ENV=production \
  ./bin/rails assets:precompile

CMD ["sh", "./scripts/app", "start"]
