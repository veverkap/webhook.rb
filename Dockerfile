FROM ruby:3.0

LABEL maintainer="webhook@veverka.net"

ENV RACK_ENV production
ENV MAIN_APP_FILE webhook.rb

RUN mkdir -p /usr/src/app

ADD startup.sh /

WORKDIR /usr/src/app

EXPOSE 80

CMD ["/bin/bash", "/startup.sh"]