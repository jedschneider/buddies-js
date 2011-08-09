Sparkles = {}
Sparkles.Model = Backbone.Model.extend
  set: (atts, options) ->
    if(@attribute_types)
      for k,v of atts
        if(@attribute_types[k] == 'integer')
          atts[k] = parseInt(atts[k])
    _.bind(Backbone.Model.prototype.set, @)(atts, options)

Sparkles.Collection = Backbone.Collection.extend
  comparator: (obj)-> obj.get('order') || 9999.0

Sparkles.CachedCollection = Backbone.Collection.extend
  fetch: (opts = {}) ->
    success = opts.success
    if(@__cache__)
      _.defer =>
        success(@__cache__) if success
        @trigger 'reset'
    else
      opts.success = (coll, resp) =>
        @__cache__ = coll
        success(coll, resp) if success
      Backbone.Collection.prototype.fetch.call(@, opts)
