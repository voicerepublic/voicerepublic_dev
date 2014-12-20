Sencha.factory("config", function() {
  return {
    talk: {
        channel: 'asdf'
    },
    user: {
        channel: 'fdsa'
    },
    starts_at: 1234567,
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
    flags: {
      "blackboxReady": false
    }
  };
});
