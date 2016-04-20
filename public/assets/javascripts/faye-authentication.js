function FayeAuthentication(client, endpoint, options) {
  this._client = client;
  this._endpoint = endpoint || '/faye/auth';
  this._signatures = {};
  this._outbox = {};
  this._options = options || {};
  this._options.retry_delay = this._options.retry_delay || 1000;
  this._waiting_signatures = [];
  this._timer = null;
}

FayeAuthentication.prototype.endpoint = function() {
  return (this._endpoint);
};

FayeAuthentication.prototype.resolveWaitingSignatures = function() {
  if (this._waiting_signatures.length == 0) {
    return ;
  }
  var self = this;
  var messages = [];
  $.each(this._waiting_signatures, function(key, params) {
    messages.push(params);
  });
  this._waiting_signatures = [];
  messages = messages.sort(function(a, b) {
    return (a.channel > b.channel);
  });

  $.post(self.endpoint(), {messages: messages}, function(response) {
    $.each(messages, function(key, params) {
      var signature = $.grep(response.signatures || [], function(e) {
        return (e.channel == params.channel && e.clientId == params.clientId);
      })[0];
      if (typeof signature === 'undefined') {
        self.error('No signature found in ajax reply for channel ' + params.channel + ' and clientId ' + params.clientId);
      } else if (signature && !signature.signature) {
        self.error('Error when fetching signature for channel ' + params.channel + ' and clientId ' + params.clientId + ', error was : "' + signature.error + '"');
      }
      Faye.Promise.resolve(self._signatures[params.clientId][params.channel], signature ? signature.signature : null);
    });
  }, 'json').fail(function(xhr, textStatus, e) {
    self.error('Failure when trying to fetch JWT signature for data "' + JSON.stringify(messages) + '", error was : ' + textStatus);
    $.each(messages, function(key, params) {
      Faye.Promise.resolve(self._signatures[params.clientId][params.channel], null);
    });
  });
};

FayeAuthentication.prototype.signMessage = function(message, callback) {
  var channel = message.subscription || message.channel;
  var clientId = message.clientId;

  var self = this;
  if (!this._signatures[clientId]) {
    this._signatures[clientId] = {};
  }
  if (this._signatures[clientId][channel]) {
    this._signatures[clientId][channel].then(function(signature) {
      message.signature = signature;
      if (!message.retried) {
        self._outbox[message.id] = {message: message, clientId: clientId};
      }
      callback(message);
    });
  } else {
    var promise = self._signatures[clientId][channel] = new Faye.Promise();
    promise.then(function(signature) {
      message.signature = signature;
      if (!message.retried) {
        self._outbox[message.id] = {message: message, clientId: clientId};
      }
      callback(message);
    });
    this._waiting_signatures.push({channel: channel, clientId: clientId});
    clearTimeout(this._timer);
    this._timer = setTimeout(function() {
      self.resolveWaitingSignatures();
    }, 200);
  }
}

FayeAuthentication.prototype.outgoing = function(message, callback) {
  if (this.authentication_required(message)) {
    this.signMessage(message, callback);
  } else {
    callback(message);
  }
};

FayeAuthentication.prototype.authentication_required = function(message) {
  var subscription_or_channel = message.subscription || message.channel;
  if (message.channel == '/meta/subscribe' || message.channel.lastIndexOf('/meta/', 0) !== 0) {
    if(this._options.whitelist) {
      try {
        return (!this._options.whitelist(subscription_or_channel));
      } catch (e) {
        this.error("Error caught when evaluating whitelist function : " + e.message);
      }
    }
    return (true);
  }
  return (false);
};

FayeAuthentication.prototype.incoming = function(message, callback) {
  var outbox_message = this._outbox[message.id];
  if (outbox_message && message.error) {
    var channel = outbox_message.message.subscription || outbox_message.message.channel;
    this._signatures[outbox_message.clientId][channel] = null;
    outbox_message.message.retried = true;
    delete outbox_message.message.id;
    delete this._outbox[message.id];
    var self = this;
    setTimeout(function() {
      self._client._sendMessage(outbox_message.message, {}, callback);
    }, this._options.retry_delay);
  } else {
    callback(message);
  }
};

$(function() {
  Faye.extend(FayeAuthentication.prototype, Faye.Logging);
});
