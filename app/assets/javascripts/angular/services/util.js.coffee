# The UtilService is just a container for utility functions.
window.sencha.factory "util", ->

  toHHMMSS = (str) ->
    sec_num = parseInt(str, 10)
    hours   = Math.floor(sec_num / 3600)
    minutes = Math.floor((sec_num - (hours * 3600)) / 60)
    seconds = sec_num - (hours * 3600) - (minutes * 60)
    hours   = "0"+hours   if hours   < 10
    minutes = "0"+minutes if minutes < 10
    seconds = "0"+seconds if seconds < 10
    hours+':'+minutes+':'+seconds

  merge = (target, src) ->
    array = Array.isArray src
    dst = array && [] || {}
    if array
      target ||= []
      dst = dst.concat target
      src.forEach (e, i) ->
        if typeof target[i] == 'undefined'
          dst[i] = e
        else if typeof e == 'object'
          dst[i] = merge(target[i], e)
        else
          if target.indexOf(e) == -1
            dst.push(e)
    else
      if target && typeof target == 'object'
        Object.keys(target).forEach (key) ->
          dst[key] = target[key]
      Object.keys(src).forEach (key) ->
        if typeof src[key] != 'object' || !src[key]
          dst[key] = src[key]
        else
          if !target[key]
            dst[key] = src[key]
          else
            dst[key] = merge(target[key], src[key])
    dst

  # expose
  { merge, toHHMMSS }
