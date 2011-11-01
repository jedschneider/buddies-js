# underscore extensions

_.mixin
  capitalize : (str)->
    str.charAt(0).toUpperCase() + str.substring(1).toLowerCase()