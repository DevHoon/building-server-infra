FROM ubuntu

RUN apt-get update
RUN apt-get install -y memcached
RUN apt-get clean

CMD ["/usr/bin/memcached", "-vv"]
USER memcache

EXPOSE 11211
