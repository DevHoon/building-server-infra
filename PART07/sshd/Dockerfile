FROM base

RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd

## Create user
RUN useradd -m naoya
RUN mkdir -p /home/naoya/.ssh; chown naoya /home/naoya/.ssh; chmod 700 /home/naoya/.ssh
ADD ./authorized_keys /home/naoya/.ssh/authorized_keys
RUN chown naoya /home/naoya/.ssh/authorized_keys; chmod 600 /home/naoya/.ssh/authorized_keys

CMD ["/usr/sbin/sshd","-D"]
EXPOSE 22
