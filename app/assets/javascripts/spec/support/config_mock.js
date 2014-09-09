Livepage.factory("config", function() {
  return {
   "user": {
        "id": 42,
        "name": "guest guest_6ecc09f2-07d9-4c5c-9a9b-428e260e694a",
        "role": "listener",
        "image": "http://lorempixel.com/80/80/people/0/",
        "stream": "t1-u42",
        "channel": "/t1/u42"
      },
      "initial_state": "Registering",
      "statemachine": [
        {
          "name": "Registered",
          "from": "Registering",
          "to": "Waiting"
        },
        {
          "name": "TalkStarted",
          "from": "Waiting",
          "to": "Listening"
        },
        {
          "name": "MicRequested",
          "from": "Listening",
          "to": "ExpectingPromotion"
        },
        {
          "name": "Promoted",
          "from": "ExpectingPromotion",
          "to": "OnAir"
        },
        {
          "name": "Promoted",
          "from": "Listening",
          "to": "AcceptingPromotion"
        },
        {
          "name": "PromotionAccepted",
          "from": "AcceptingPromotion",
          "to": "OnAir"
        },
        {
          "name": "PromotionDeclined",
          "from": "AcceptingPromotion",
          "to": "Listening"
        },
        {
          "name": "Demoted",
          "from": "OnAir",
          "to": "Listening"
        },
        {
          "name": "Registered",
          "from": "GuestRegistering",
          "to": "OnAir"
        },
        {
          "name": "Registered",
          "from": "HostRegistering",
          "to": "HostOnAir"
        },
        {
          "name": "TalkEnded",
          "from": "*",
          "to": "Loitering"
        }
      ],
      "talk_id": 1,
      "host": "Munen Lafon",
      "title": "asfd",
      "teaser": "asdf",
      "session": {
        "8": {
          "id": 8,
          "name": "Munen Lafon",
          "role": "host",
          "image": "http://localhost:3000/media/W1siZmYiLCIvaG9tZS9tdW5lbi9zcmMvdm9pY2VyZXB1YmxpYy9hcHAvYXNzZXRzL2ltYWdlcy9kZWZhdWx0cy91c2VyLWF2YXRhci5qcGciXSxbInAiLCJ0aHVtYiIsIjEwMHgxMDAjbnciXV0/user-avatar.jpg?sha=40350d82",
          "stream": "t1-u8",
          "channel": "/t1/u8",
          "state": "HostOnAir"
        }
      },
      "talk": {
        "state": "live",
        "remaining_seconds": -522160,
        "starts_in": -524000,
        "ends_in": -522160,
        "links": {
          "mp3": "/vrmedia/1.mp3",
          "m4a": "/vrmedia/1.m4a",
          "ogg": "/vrmedia/1.ogg"
        },
        "duration": 1800,
        "channel": "/t1/public"
      },
      "starts_at": 1406110620,
      "ends_at": 1406112420,
      "fayeClientUrl": "http://localhost:9292/faye/client.js",
      "fayeUrl": "http://localhost:9292/faye",
      "subscriptions": {
        "/t1/public": {
          "server": "http://localhost:9292/faye",
          "timestamp": 1406634620248,
          "channel": "/t1/public",
          "signature": "9ee821121123304427e836bde919612c22dda9cf"
        },
        "/t1/u42": {
          "server": "http://localhost:9292/faye",
          "timestamp": 1406634620249,
          "channel": "/t1/u42",
          "signature": "7df35ffa0097e43720003fa93bff2a8e6781deff"
        }
      },
      "namespace": "t1",
      "fullname": "guest guest_6ecc09f2-07d9-4c5c-9a9b-428e260e694a",
      "user_id": 42,
      "handle": "u42",
      "role": "listener",
      "stream": "t1-u42",
      "streaming_server": "rtmp://localhost/record",
      "discussion": [

      ],
      "guests": [

      ],
      "participants": [

      ],
      "blackbox": {"silence_level":0,"silence_timeout":2000},
      "loopback": null,
      "blackbox_path": "/assets/Blackbox11.swf"
    };
});
