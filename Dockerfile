FROM ruby:2.7.2-alpine

RUN apk --no-cache upgrade && \
  apk add --no-cache \
  build-base \
  vim


WORKDIR /app

COPY Gemfile* /app/

RUN gem update bundler && bundle install --jobs "$(nproc)" --retry 2

COPY . /app

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
