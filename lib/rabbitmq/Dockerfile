FROM rabbitmq

MAINTAINER Phil Hofmann "phil@200ok.ch"

RUN rabbitmq-plugins enable rabbitmq_stomp
RUN rabbitmq-plugins enable rabbitmq_web_stomp
RUN rabbitmq-plugins enable rabbitmq_management
RUN rabbitmq-plugins enable rabbitmq_management_visualiser

EXPOSE 15671 15672
EXPOSE 15674 61613
