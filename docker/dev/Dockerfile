## -*- docker-image-name: "vr/rails-base" -*-

FROM debian:jessie
MAINTAINER josef@voicerepublic.com

## Essentials
RUN apt-get update && \
    apt-get install curl git -y

## Java 8 Oracle
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    apt-get install oracle-java8-installer -y 

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
   
## Leiningen
RUN curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > ~/bin/lein && \
    chmod a+x ~/bin/lein && \
    lein

## Node 7
RUN curl -sL https://deb.nodesource.com/setup_7.x | -E bash - && \
    apt-get install -y nodejs && \

## Ruby 2.1.2
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc && \
    echo 'eval "$(rbenv init - $SHELL)"' >> ~/.zshrc && \
    export PATH="$HOME/.rbenv/bin:$PATH" && \
    eval "$(rbenv init - $SHELL)" && \ 
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# install ruby dependencies
RUN apt-get install -y libssl-dev libreadline-dev zlib1g-dev && \
    rbenv install -s 2.1.2 && \
    rbenv global 2.1.2 && \
    gem install bundler

WORKDIR /usr/src/app

ADD Gemfile* /usr/src/app/
