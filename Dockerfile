FROM ubuntu:18.04

ADD . /u18cpp

RUN /u18cpp/install.sh && rm -rf /tmp && mkdir /tmp && chmod 1777 /tmp

ENV BASH_ENV "/etc/drydock/.env"
