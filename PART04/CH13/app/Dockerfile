FROM ubuntu:12.04
RUN apt-get update
RUN apt-get -y install ruby1.9.3
RUN gem install bundler
ADD . /src
RUN cd /src && bundle install
EXPOSE 4567
WORKDIR /src
CMD cd /src && rackup -p4567
