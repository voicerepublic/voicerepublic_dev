# The SessionService is the single source for insession
# data and contains the session logic.
#
# CHECK Maybe it makes sense to split this further into
#  * stuff that belongs to the user 
#  * stuff that belongs to the whole session (all users)
Livepage.factory 'session', ($log, privatePub, util, $rootScope,
                                    upstream, config, blackbox) ->

  users = config.session

  id = config.user_id
  onair = false

  fsm = StateMachine.create
    initial: 'Initializing'
    events: config.statemachine
    callbacks:
      onSoundChecking: ->
        alert 'soundcheck'
        fsm.SucceededSoundCheck()
      onListening: ->
        # FIXME don't use a timeout here
        setTimeout (-> upstream.put 'register', user: { id: config.user_id }), 1000
      onOnAir: ->
        onair = true
      onHosting: ->
        onair = true
      onafterOnAir: ->
        onair = false

  promote = (name) ->
    for id, user of users when user.name == name
      upstream.put 'promote', id: user.id
  demote = (name) ->
    for id, user of users when user.name == name
      upstream.put 'demote', id: user.id

  guests = ->
    (user for id, user of users when user.role == 'guest')
  participants = ->
    (user for id, user of users when user.role == 'participant')

  dataHandler = (data) ->
    data = data.data # unpack private_pub message
    switch data.command
      when 'register' then users[data.user.id] = data.user
      when 'promote'
        fsm.Promoted() if data.id == config.user_id
        users[data.id].role = 'guest'
      when 'demote'
        # fsm.Demoted() if data.id == config.user_id
        users[data.id].role = 'participant'
      when undefined then $log.info 'Ignoring malformed message.'
      else $log.error "Unknown event command: #{data.command}"
    $rootScope.$apply()

  privatePub.subscribe "/#{config.namespace}/public", dataHandler
  # privatePub.subscribe "/#{config.namespace}/private/#{name}", dataHandler

  # expose
  {
    onair
    name: config.fullname
    fsm 
    promote
    demote
    guests
    participants
  }
