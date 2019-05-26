FROM ubuntu:16.04

ENV DATABASE_URL=127.0.0.1

RUN apt-get update && apt-get install -y mongodb-server ruby-full ruby-dev build-essential
RUN gem install bundler

COPY . /reddit/

RUN cd /reddit && bundle install
RUN chmod 0777 /reddit/start.sh

CMD ["/reddit/start.sh"]
