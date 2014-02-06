# Since angular's dependency injection decides in what order to
# resolve dependencies this could totally go into the html page
# rendered by rails.
Livepage.factory "config", ->
  {
    fayeClientUrl: 'http://kluuu.com:9293/faye/client.js'
    fayeUrl: 'http://kluuu.com:9293/faye'
    timestamp: 1302306682972
    signature: '123'
    namespace: 'talk123'
  }
