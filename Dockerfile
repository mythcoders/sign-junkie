FROM ghcr.io/mythcoders/gaia:latest AS base

ADD Gemfile* $APP_HOME/

RUN apk add --no-cache --virtual build-deps build-base && \
  apk upgrade && \
  apk add figlet imagemagick libxml2-dev libxslt-dev && \
  wget http://www.figlet.org/fonts/trek.flf -P /usr/share/figlet/fonts && \
  bundle install --jobs=4 && \
  apk del build-deps

COPY package.json yarn.lock $APP_HOME/
RUN yarn install --frozen-lockfile

EXPOSE $APP_PORT

FROM base AS build

ADD . $APP_HOME/

RUN ASSETS_PRECOMPILE=1 SECRET_KEY_BASE=1 NODE_ENV=production RAILS_ENV=production \
  bundle exec rake assets:precompile

CMD ["sh", "./scripts/app", "start"]
