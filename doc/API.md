VoiceRepublic API
-----------------

## Authentication

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

    GET /api/talks

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
      speakers: null
    }



