FROM ruby:3.0

LABEL maintainer="webhook@veverka.net"

ENV RACK_ENV production

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app
COPY . /code

RUN bundle install

EXPOSE 80

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "80"]