# For now the UpstreamService directly publishes to Faye,
# but eventually this will have to become ajax calls.
Livepage.factory 'upstream', (config, privatePub, $log) ->

  publish = (data) ->
    privatePub.publish "/#{config.namespace}/public", data

  register = (data) ->
    temp = { users: {} }
    temp.users[data.name] = {
      name: data.name
      role: 'participant'
      image: "http://lorempixel.com/80/80/people/#{Math.round(Math.random()*9)+2}/"
    }
    publish temp

  update = (name, attrs) ->
    temp = { users: {} }
    temp.users[name] = attrs
    publish temp

  # expose
  {
    register
    update
  }
