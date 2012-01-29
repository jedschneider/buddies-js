Sparkles = {}

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
