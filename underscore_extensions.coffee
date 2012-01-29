_.mixin
  capitalize : (str)->
    str.charAt(0).toUpperCase() + str.substring(1).toLowerCase()
  hasKey: (ob, k) ->
    ob.hasOwnProperty(k)
  isRegularNumber: (n) ->
    _.isNumber(n) and not _.isNaN(n) and n != Infinity and n != -Infinity
  complement: (f) -> (args...) -> not f(args...)