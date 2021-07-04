# vrfun

This is a container project for microservices built on top of duct.

## Developing

### Setup

When you first clone this repository, run:

```sh
lein duct setup
```

This will create files for local configuration, and prep your system
for the project.

### Environment

To begin developing, start with a REPL.

```sh
lein repl
```

Then load the development environment.

```clojure
user=> (dev)
:loaded
```

Run `go` to prep and initiate the system.

```clojure
dev=> (go)
:duct.server.http.jetty/starting-server {:port 3002}
:initiated
```

By default this creates a web server at <http://localhost:3002> since the other ports are used by the rails applications.

When you make changes to your source files, use `reset` to reload any
modified files and reset the server.

```clojure
dev=> (reset)
:reloading (...)
:resumed
```

### Testing

Testing is fastest through the REPL, as you avoid environment startup
time.

```clojure
dev=> (test)
...
```

But you can also run tests through Leiningen.

```sh
lein test
```

### Production

In order to build the production image run following script:

```sh
./build.sh
```

This will create the `jerben/vrfun` image.

By editing `docker-compose.yml` you can easily configure port mapping or set envirnoment variables. Finally start up the services:

```sh
docker-compose up
```

## Legal

Copyright © 2017 Voicerepublic
