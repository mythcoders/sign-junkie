FROM ruby:2.5.1-alpine

RUN apk add --update build-base postgresql-dev tzdata nodejs imagemagick

WORKDIR /app
ADD Gemfile Gemfile.lock /app/

RUN gem install bundler
RUN bundle install

ADD . .

CMD ["puma"]
