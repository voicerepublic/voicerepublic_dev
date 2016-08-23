# This is an ettempt to build a dockered RabbitMQ with WebStomp support.

## We currently do not use this.

# Notes

docker build -t branch14/rabbitmq .

docker run --hostname rabbit --name rabbitmq \
  -p 4369:4369 \
  -p 5671:5671 \
  -p 5672:5672 \
  -p 15671:15671 \
  -p 15672:15672 \
  -p 15674:15674 \
  -p 25672:25672 \
  -p 61613:61613 \
  branch14/rabbitmq

# docker start rabbitmq
docker rm rabbitmq


# 4369 - epmd
# 5671 -
# 5672 - amqp
# 15671
# 15672 - management
# 15674 - web stomp
# 25672
# 61613 - stomp
