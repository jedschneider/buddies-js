_.mixin
  capitalize : (str)->
    str.charAt(0).toUpperCase() + str.substring(1).toLowerCase()
  hasKey: (ob, k) ->
    ob.hasOwnProperty(k)
  isRegularNumber: (n) ->
    _.isNumber(n) and not _.isNaN(n) and n != Infinity and n != -Infinity
  complement: (f) -> (args...) -> not f(args...)
  deepClone: (ob) ->
    if(typeof ob == 'object')
      if(_.isArray(ob))
        _.map(ob, (x) => _.deepClone(x))
      else if (_.isNull(ob))
        null
      else
        ret = _.clone(ob)
        for k in _.keys(ret)
          ret[k] = _.deepClone(ret[k])
        return ret
    else
      return ob
