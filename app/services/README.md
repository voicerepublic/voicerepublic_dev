Services are simply classes whose instances provide a method `run`.

Services will be run as a daemon via, e.g.

    bin/service run mediator

There are a couple of utility modules to include into services for
common functionality, namely

    connector    - provides a connection to rabbitmq via `channel`
    publisher    - provides a instance method to publish to rabbitmq via `publish`
    subscriber   - provides a class method to subscribe to rabbitmq via `subscribe`
    fog_ec2      - provides a connection to aws ec2 via `fog`
    local_config - provides access to the local settings via `config`

## info

{
:consumer_tag=>"bunny-1454442867000-989668294202",
:delivery_tag=>#<Bunny::VersionedDeliveryTag:0x007fa638b0b090 @tag=1, @version=0>,
:redelivered=>false,
:exchange=>"notifications",
:routing_key=>"",
:consumer=>#<Bunny::Consumer:70175946264780 @channel_id=1 @queue=amq.gen-wrRPgcYePz9_7YgBdvnPtF> @consumer_tag=bunny-1454442867000-989668294202 @exclusive= @no_ack=true>,
:channel=>#<Bunny::Channel:70175946307660 @id=1 @connection=#<Bunny::Session:0x7fa638c1dcd0 guest@127.0.0.1:5672, vhost=/, addresses=[127.0.0.1:5672]>>
}

## prop

{:content_type=>"application/octet-stream", :delivery_mode=>2, :priority=>0}
