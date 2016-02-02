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
