FROM ruby:2.5.1-alpine

RUN apk add --update build-base postgresql-dev tzdata nodejs

WORKDIR /app
ADD Gemfile Gemfile.lock /app/
RUN bundle install

RUN rails assets:precompile

ADD . .
CMD ["puma"]
