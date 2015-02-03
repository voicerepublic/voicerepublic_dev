Sencha.factory("config", function() {
  return {
    "talk": {
        "channel": 'asdf',
        "state": 'prelive',
        "starts_in": 1337,
        "links": 'http://wikipedia.org/1337'
    },
    "user": {
        "channel": 'fdsa',
        "role": 'participant'
    },
    "starts_at": 1234567,
    "talk_id": 42,
    "host": "kluuu master",
    "title": "Great Talk on Ecoprimitivism",
    "teaser": "Ted was right!",
    "session": {
      "1": {
        "id": 1,
        "name": "kluuu master",
        "role": "participant",
        "image": "http://lorempixel.com/80/80/people/0/",
        "stream": "t42-u1",
        "state": "Hosting"
      },
      "341471": {
        "id": 341471,
        "name": "blablub blabla",
        "role": "participant",
        "image": "http://lorempixel.com/80/80/people/5/",
        "stream": "t42-u341471",
        "state": "WaitingForPromotion"
      },
      "341473": {
        "id": 341473,
        "name": "munen 無念",
        "role": "participant",
        "image": "http://lorempixel.com/80/80/people/8/",
        "stream": "t42-u341473",
        "state": "ListeningButReady"
      },
      "1337": {
        "id": 1337,
        "name": "munen 無念",
        "role": "participant",
        "image": "http://lorempixel.com/80/80/people/8/",
        "stream": "t42-u1337",
        "state": "OnAir"
      },
      "42": {
        "id": 42,
        "name": "munen 無念",
        "role": "participant",
        "image": "http://lorempixel.com/80/80/people/8/",
        "stream": "t42-u42",
        "state": "ExpectingPromotion"
      },
      "7": {
        "id": 7,
        "name": "munen 無念",
        "role": "participant",
        "image": "http://lorempixel.com/80/80/people/8/",
        "stream": "t42-u7",
        "state": "AcceptingPromotion"
      },
      "2": {
        "id": 2,
        "name": "munen 無念",
        "role": "participant",
        "image": "http://lorempixel.com/80/80/people/8/",
        "stream": "t42-u2",
        "state": "Listening"
      },
      "3": {
        "id": 3,
        "name": "munen 無念",
        "role": "listener",
        "image": "http://lorempixel.com/80/80/people/8/",
        "stream": "t42-u3",
        "state": "Listening"
      }
    },
    "fayeClientUrl": "http://172.21.21.171:9292/faye/client.js",
    "fayeUrl": "http://172.21.21.171:9292/faye",
    "subscription": {
      "server": "http://172.21.21.171:9292/faye",
      "timestamp": 1392201113767,
      "channel": "/t42/public",
      "signature": "9202ab90baecca5fac9ad6e208fed49928401701"
    },
    "namespace": "t42",
    "fullname": "blablub blabla",
    "user_id": 341471,
    "handle": "u341471",
    "role": "listener",
    "initial_state": "foo",
    "statemachine": [
      {
        "name": "Registered",
        "from": "Registering",
        "to": "Listening"
      },
      {
        "name": "RequestedMic",
        "from": "Listening",
        "to": "WaitingForPromotion"
      },
      {
        "name": "Promoted",
        "from": "WaitingForPromotion",
        "to": "OnAir"
      },
      {
        "name": "Promoted",
        "from": "Listening",
        "to": "OnAir"
      },
      {
        "name": "Demoted",
        "from": "OnAir",
        "to": "ListeningButReady"
      },
      {
        "name": "Promoted",
        "from": "ListeningButReady",
        "to": "OnAir"
      }
    ],
    "stream": "t42-u341471",
    "streaming_server": "rtmp://kluuu.com/recordings",
    "flags": {
      "settings": true,
      "blackboxReady": false
    }
  };
});
