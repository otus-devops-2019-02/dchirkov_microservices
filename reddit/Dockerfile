FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y mongodb-server ruby-full ruby-dev build-essential git
RUN gem install bundler
#RUN git clone -b gitlab-ci-1 http://35.210.200.83/homework/example.git

COPY reddit /reddit

#COPY start.sh /start.sh

RUN cd /reddit && bundle install
RUN chmod 0777 /reddit/start.sh

CMD ["/reddit/start.sh"]
