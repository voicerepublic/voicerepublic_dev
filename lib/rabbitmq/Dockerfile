FROM rabbitmq

MAINTAINER Phil Hofmann "phil@200ok.ch"

RUN rabbitmq-plugins enable rabbitmq_stomp && \
    rabbitmq-plugins enable rabbitmq_web_stomp && \
    rabbitmq-plugins enable rabbitmq_management && \
    rabbitmq-plugins enable rabbitmq_management_visualiser

EXPOSE 15671 15672
EXPOSE 15674 61613
