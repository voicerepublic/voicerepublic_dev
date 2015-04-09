# Google Analytics (ga) Event Component
#
# Usage
#
# Annotate nodes with `data-ga-event` attributes, the value will be
# split by spaces, the arguments are
#
# 0. event (required)
#    The dom event to bind on. E.g. click, mouseup, etc.
#
# 1. category (required)
#    The name you supply for the group of objects you want to track.
#
# 2. action (required)
#    A string that is uniquely paired with each category, and commonly
#    used to define the type of user interaction for the web object.
#
# 3. label (optional)
#    An optional string to provide additional dimensions to the event
#    data.
#
# 4. value (optional)
#    An integer that you can use to provide numerical data about the
#    user event.
#
# 5. non-interaction (optional)
#    A boolean that when set to true, indicates that the event hit
#    will not be used in bounce-rate calculation.
#
# Example
#
#   <a href='#' onclick='play()' data-ga-event='click player play'>play</a>
#
# Further Reading
#
# * https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide
#
attribute = 'data-ga-event'

initialize = (element, value) ->
  #console.log "initialize: #{attribute} (#{value})"

  [event, args...] = value.split(' ')
  $(element).bind event, ->
    if _gaq?
      _gaq.push ['_trackEvent'].concat(args)
    else
      console.log "GAEvent: #{args.join(' ')}"

# initializer
$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
