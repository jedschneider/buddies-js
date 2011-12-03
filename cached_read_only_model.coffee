# The Service Catalog is read-only for this app, and we gain a lot of
# simplicity by caching it. Is stale data bad? What's the worst that can happen
# when somebody updates the service catalog and we don't see it right away?
#
# TODO: How do we clear these caches between tests???

CachedReadOnlyModel = Backbone.Model.extend({})
# We override extend so that we can add static methods to the class
CachedReadOnlyModel.extend = (args...) ->
  clazz = Backbone.Model.extend.apply(@, args)
  class_name = (args[0].class_name)
  _.extend clazz,
    find: (id) ->
      if(x = (@_cache and @_cache[id]))
        return x
      else
        s = if(class_name) then " for #{class_name}" else ""
        throw "Model ##{id} is not in cache#{s}!"
    does_cache_contain: (id) -> !!(@_cache and @_cache[id])
    add_to_cache: (model) ->
      @_cache ||= {}
      @_cache[model.id] = model
  return clazz

CachedReadOnlyCollection = Backbone.Collection.extend
  initialize: ->
    probably = (@model.find and @model.does_cache_contain and @model.add_to_cache)
    assert(probably, "CacheReadOnlyCollection model must be a CachedReadOnlyModel!")
  fetch: (opts = {}) ->
    {success} = opts
    opts.success = (args...)=>
      @model.add_to_cache(x) for x in @models
      success(args...) if success
    # Is this right?
    Backbone.Collection::fetch.call(@, opts)

CachedFetchOnceReadOnlyCollection = CachedReadOnlyCollection.extend
  fetch: (opts = {}) ->
    success = (opts.success or ->)
    if @_fetched
      _.defer =>
        @trigger 'reset'
        success()
    else
      opts.success = =>
        @_fetched = true
        success()
      CachedReadOnlyCollection::fetch.call(@, opts)
