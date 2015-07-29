# ELK Setup Instructions


## Table of Contents

* Preface
* Install RabbitMQ
* Join RabbitMQ Cluster
* Install ELK Stack Prerequisites
* Install & Setup Kibana
* Install & Setup Elasticsearch
* Install & Setup Logstash
* Appendix


## Preface

For the ELK stack memory (RAM) is the limiting factor. 512 MB is not
enough! It will run to some extent, but it will be dead slow. I mean
slow as in literaly minutes to even come up with the Web UI of Kibina.

That said, the following setup has been tested with a 512 MB (and resp.
1 GB) VM running Debian Wheezy, which I'll refer to as ELK.

With Debian Wheezy comes RabbitMQ 2.8.4, which is too old (I wasn't
able to cluster with this version). A more recent version can be
installed from rabbitmq.com directly, this will install version
3.5.4. This is the path we're going here.

And please save yourself some headache by setting a proper hostname
BEFORE installing RabbitMQ.

    hostname <your-hostname-here>

## Install RabbitMQ

    echo 'deb http://www.rabbitmq.com/debian/ testing main' > /etc/apt/sources.list.d/rabbitmq.list
    wget -O - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add -
    aptitude update
    aptitude install -y rabbitmq-server

Install the management web ui

    rabbitmq-plugins enable rabbitmq_management
    /etc/init.d/rabbitmq-server restart


## Join RabbitMQ Cluster

### On STAGING and/or LIVE

Open the ports 4369 & 25672 to the ip you want to cluster from, e.g.

    REMOTE_IP=136.243.209.122

    iptables -I INPUT -p tcp -s $REMOTE_IP --dport 4369 -j ACCEPT
    iptables -I INPUT -p tcp -s $REMOTE_IP --dport 25672 -j ACCEPT

Look up the authoritative erlang cookie

    cat /var/lib/rabbitmq/.erlang.cookie

It SHOULD be

    JGRBISALEEAKRXKQFYFR

### On ELK

Set the erlang cookie from above

    ERLANG_COOKIE=JGRBISALEEAKRXKQFYFR
    /etc/init.d/rabbitmq-server stop
    echo -n $ERLANG_COOKIE > /var/lib/rabbitmq/.erlang.cookie
    /etc/init.d/rabbitmq-server start

Add host entries for the machines you want to cluster, e.g.

    echo "136.243.52.230 voicerepublic-staging" >> /etc/hosts
    echo "136.243.52.231 voicerepublic-production" >> /etc/hosts

Finally cluster the machines

    rabbitmqctl stop_app
    rabbitmqctl reset
    rabbitmqctl join_cluster rabbit@voicerepublic-staging
    rabbitmqctl join_cluster rabbit@voicerepublic-production
    rabbitmqctl start_app


## Install ELK Stack Prerequisites

Install JRE & JDK 8

    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
    aptitude update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections
    aptitude install oracle-java8-installer


## Install & Setup Kibana

Fetch and unpack

    wget --no-check-certificate -O /tmp/kibana.tar.gz https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
    mkdir -p /opt/kibana
    tar xvf /tmp/kibana.tar.gz --strip-components=1 -C /opt/kibana
    rm /tmp/kibana.tar.gz

Change config to only allow access from localhost

    sed -i -e 's/0\.0\.0\.0/localhost/' /opt/kibana/config/kibana.yml

Kibina doesn't come with an init scipt

    wget --no-check-certificate -O /etc/init.d/kibana4 \
      https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4
    chmod a+x /etc/init.d/kibana4
    update-rc.d kibana4 defaults 96 9
    /etc/init.d/kibana4 start


## Install & Setup Elasticsearch

    wget --no-check-certificate https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.0.deb
    dpkg -i elasticsearch-1.7.0.deb
    /etc/init.d/elasticsearch start


## Install & Setup Logstash

    wget --no-check-certificate https://download.elastic.co/logstash/logstash/packages/debian/logstash_1.5.3-1_all.deb
    dpkg -i logstash_1.5.3-1_all.deb

Confiugre Logstash: This is what worked for me, but I guess in
production it would make sense to omit the line `stdout { codec => rubydebug }`


```
cat - > /etc/logstash/conf.d/rabbitmq.conf <<EOF
input {
  rabbitmq {
    host => 'localhost'
    exchange => 'metrics'
  }
}

output {
  elasticsearch { host => localhost }
  stdout { codec => rubydebug }
}
EOF
```

Now start Logstash

    /etc/init.d/logstash start

And your done!


## Appendix

### Logs

    tail -f /var/log/logstash/*

### Troubleshoot RabbitMQ Clustering

    dpkg -l rabbitmq-server
    cat /var/lib/rabbitmq/.erlang.cookie

    epmd -kill

### Troubleshoot Logstash

    /etc/init.d/logstash stop

    /opt/logstash/bin/logstash -e \
      "input { rabbitmq { host => 'localhost' exchange => 'metrics' } }"

### Elasticsearch plugins

Check (Bigdesk Support Matrix)[https://github.com/lukas-vlcek/bigdesk#support-matrix]

    /usr/share/elasticsearch/bin/plugin -install lukas-vlcek/bigdesk/2.4.0
    /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head

Then browse http://localhost:9200

### Setup Nginx as a reverse proxy (TODO)

    aptitude install -y nginx apache2-utils
    htpasswd -c /etc/nginx/htpasswd.users kibanaadmin
    cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default-original
    # TODO ...
    /etc/init.d/nginx reload

### SSH Portforwards (TODO)

List of ports and what's listening

* 5601 Kibana
* 15672 RabbitMQ management console

Hence, in `~/.ssh/config` you will want to put someting like...

    Host elk
      User root
      Hostname 136.243.209.122
      LocalForward 5601 localhost:5601
      LocalForward 15675 localhost:15672





root@host2:~# rabbitmqctl join_cluster rabbit@host1
Clustering node rabbit@host2 with 'rabbit@host1' ...
Error: unable to connect to nodes ['rabbit@host1']: nodedown

DIAGNOSTICS
===========

attempted to contact: ['rabbit@host1']

rabbit@host1:
* connected to epmd (port 4369) on host1
* node rabbit@host1 up, 'rabbit' application running

current node details:
- node name: 'rabbitmq-cli-6383@host2'
- home dir: /var/lib/rabbitmq
- cookie hash: 0Les7JLLB4Q5zX5hsDv0Yw==
