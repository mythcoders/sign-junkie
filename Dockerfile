FROM ruby:2.5.1
ENTRYPOINT [ "bundle", "exec" ]

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /app
RUN rm -rf tmp/*
ADD . /app


CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]