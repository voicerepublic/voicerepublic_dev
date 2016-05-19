## Authentication

### Endpoint

`POST /api/sessions`

### Query Parameters

* `email`
* `password`

### Example query
```
curl -H "Content-Type: application/json"  -H 'Accept: application/json' -d '{"email":"hans@example.com","password":"you_cant_crack_me"}' -X POST https://voicerepublic.com/api/sessions

```

### Response

JSON representation of a user. This includes an authentication token for
future API requests as well as a list of Series.

```
{

  "id":2,
  "authentication_token":"hx_ZRHyj3yodPkQxVFTw",
  "firstname":"Munen Alain M.",
  "lastname":"Lafon",
  "created_at":"2013-08-08T16:21:45.469+02:00",
  "updated_at":"2015-06-25T17:40:16.216+02:00",
  "email":"munen@voicerepublic.com",
  "sign_in_count":199,
  "last_sign_in_at":"2015-06-25T16:45:49.106+02:00",
  "about":"some about text",
  "timezone":"Berlin",
  "website":"http://your_website.com",
  "summary":"I'm a Zen Buddhist and enjoy reading ancient texts as well as contemplating and continuously re-examining life and myself along with the universe.",
  "credits":1000,
  "purchases_count":0,
  "series":{"244":"On reproducability",
    "166282":"Pure Override joy",
    "502":"My Talks",
    "471":"ZHAW,
    HS 14/15 - Web3"
  }
}
```

### Option 1: Request Parameters

You can authenticate passing the `user_email` and `user_token` params
as query params:

    <ENDPOINT>?user_email=alice@example.com&user_token=1G8_s7P-V-4MGojaKD7a

### Option 2: Request Headers

You can also use request headers:

    X-User-Email alice@example.com
    X-User-Token 1G8_s7P-V-4MGojaKD7a

## Resources (1)

### Talks

#### Endpoint

`GET /api/talks`

#### Query Parameters

* `limit`, used for paging
* `offset`, used for paging
* `order`, sort order, e.g. `starts_at`, `processed_at`
* `reverse`, used to reverse the sort order
* `featured_from`, if set will filter for talks which have `featured_from` set
* `state`, if set will filter for talks which have `state` set to the given value

##### States

* `prelive`
* `halflive`
* `live`
* `postlive`
* `processing`
* `archived`

#### Response

An array of talk objects:

```
{
  id: 46,
  title: "Some Talk's Title",
  venue_id: 157,
  starts_at: "2014-04-02T20:19:00.000+02:00",
  ends_at: "2014-04-02T21:49:00.000+02:00",
  ended_at: "2014-04-03T09:26:49.908+02:00",
  collect: true,
  created_at: "2014-04-02T22:21:52.009+02:00",
  updated_at: "2014-07-02T15:42:50.750+02:00",
  teaser: "I'll tease you",
  description: "Here a summary of the talk.",
  duration: 90,
  image_uid: null,
  featured_from: null,
  state: "postlive",
  started_at: "2014-04-02T22:21:57.702+02:00",
  processed_at: null,
  play_count: 0,
  starts_at_date: "2014-04-02",
  starts_at_time: "20:19",
  uri: "vr-46",
  recording_override: null,
  related_talk_id: null,
  grade: null,
  language: "en",
  slug: "some-title",
  format: null,
  speaker_list: null
}
```

### Upload Talks

#### Endpoint

`GET /api/uploads`

#### Query Parameters

* `title`
* `starts\_at\_time`: Using the format `/\A\d\d:\d\d\z/`
* `starts\_at\_date`: Using the format `/\A\d{4}-\d\d-\d\d\z/`
* `duration`: Duration in minutes
* `tag\_list`: Comma separated list of tags
* `description`
* `language`: Language in ISO format
* `user\_override\_uuid`: Public URL to an audio file (supported formats: mp3, m4a, wav, ogg)
* `venue\_id`: ID to your Series

#### Example query
```
curl -H "Content-Type: application/json"  -H 'Accept: application/json' -d '{"talk":{"title":"Some awesome title","starts_at_time":"15:57","starts_at_date":"2015-06-25","duration":60,"collect":false,"tag_list":"lorem, ipsum, dolor","description":"Some talk description","language":"en","user_override_uuid":"http://s3.amazon.com/fake_bucket/nothing_here","venue_id":166348},"user_token":"Zy4mgMtAind_zyHCLmFf","user_email":"hans1@example.com"}' https://voicerepublic.com/api/uploads
```

#### Response

JSON representation of the created talk:

```
{
  "id":2714,
  "title":"Some awesome title",
  "venue_id":166348,
  "starts_at":"2015-06-25T15:57:00.000+02:00",
  "ends_at":"2015-06-25T16:27:00.000+02:00",
  "ended_at":null,
  "collect":true,
  "created_at":"2015-06-25T17:37:04.808+02:00",
  "updated_at":"2015-06-25T17:37:04.808+02:00",
  "teaser":null,
  "description":"Some talk description",
  "duration":30,
  "image_uid":null,
  "session":null,
  "featured_from":null,
  "state":"pending",
  "started_at":null,
  "processed_at":null,
  "play_count":0,
  "starts_at_date":"2015-06-25",
  "starts_at_time":"15:57",
  "uri":"vr-2714",
  "recording_override":null,
  "related_talk_id":null,
  "storage":{},
  "grade":null,
  "language":"en",
  "slug":"some-awesome-title",
  "speaker_list":null,
  "user_override_uuid":"http://s3.amazon.com/fake_bucket/nothing_here",
  "edit_config":null,
  "popularity":1.0,
  "penalty":1.0,
  "dryrun":false,
  "social_links":[],
  "listeners":{},
  "description_as_html":"\u003cp\u003eSome talk description\u003c/p\u003e\n"
}
```

### Bookmarks

#### Endpoint

`GET /api/bookmarks`

#### Query Parameters

* `limit`
* `offset`
* `order`
* `reverse`

#### Example query

```
curl https://voicerepublic.com/api/bookmarks?user_email=hans1@example.com&user_token=Zy4mgMtAind_zyHCLmFf
```

#### Example Response

```
[
    {
        "description_as_html": "<p>Moldovia Break Core.</p>\n",
        "duration": 30,
        "id": 3396,
        "image_url": "https://voicerepublic.com/media/W1siZmYiLCIvaG9tZS9hcHAvYXBwL3JlbGVhc2VzLzIwMTUwOTAzMTMwNTA3L2FwcC9hc3NldHMvaW1hZ2VzL2RlZmF1bHRzL3RhbGstaW1hZ2UuanBnIl1d/talk-image.jpg?sha=110aa2b5",
        "language": "en",
        "media_links": {
            "m4a": "/vrmedia/3396.m4a",
            "mp3": "/vrmedia/3396.mp3",
            "ogg": "/vrmedia/3396.ogg"
        },
        "play_count": 7,
        "popularity": 9.31953284800631e-07,
        "processed_at": "2015-02-08T15:38:22.865+01:00",
        "self_url": "http://voicerepublic.com/talks/all-is-good",
        "slides_url": null,
        "speaker_list": null,
        "teaser": "Moldovia Break Core",
        "title": "All is good"
    },
    {
        "description_as_html": "<p>pilz rock</p>\n",
        "duration": 30,
        "id": 3392,
        "image_url": "https://voicerepublic.com/media/W1siZiIsIjIwMTUvMDIvMDUvNHp3ZTZoeThqNV9yb2NrLmpwZyJdXQ?sha=b6b9f2ad",
        "language": "en",
        "media_links": {
            "m4a": "/vrmedia/3392.m4a",
            "mp3": "/vrmedia/3392.mp3",
            "ogg": "/vrmedia/3392.ogg"
        },
        "play_count": 17,
        "popularity": 1.99315781842522e-06,
        "processed_at": "2015-02-05T19:53:26.171+01:00",
        "self_url": "http://voicerepublic.com/talks/cvvc-c9c04346-9a06-4b2f-b27f-d9a6c4e6e4ee",
        "slides_url": null,
        "speaker_list": null,
        "teaser": "live ",
        "title": "Pilz Rock"
    },
    {
        "description_as_html": "<p>In The Meantime</p>\n",
        "duration": 30,
        "id": 4248,
        "image_url": "https://voicerepublic.com/media/W1siZmYiLCIvaG9tZS9hcHAvYXBwL3JlbGVhc2VzLzIwMTUwOTAzMTMwNTA3L2FwcC9hc3NldHMvaW1hZ2VzL2RlZmF1bHRzL3RhbGstaW1hZ2UuanBnIl1d/talk-image.jpg?sha=110aa2b5",
        "language": "en",
        "media_links": {
            "m4a": "/vrmedia/4248.m4a",
            "mp3": "/vrmedia/4248.mp3",
            "ogg": "/vrmedia/4248.ogg"
        },
        "play_count": 1,
        "popularity": 0.0,
        "processed_at": "2015-06-25T10:19:53.913+02:00",
        "self_url": "http://voicerepublic.com/talks/in-the-meantime-690a150d-0593-45aa-bf05-78ac8597cc05",
        "slides_url": null,
        "speaker_list": null,
        "teaser": "In The Meantime",
        "title": "In The Meantime"
    }
]
```
