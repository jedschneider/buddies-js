# The Service Catalog is read-only for this app, and we gain a lot of
# simplicity by caching it. Is stale data bad? What's the worst that can happen
# when somebody updates the service catalog and we don't see it right away?
#
# TODO: How does this relate to Sparkles.CachedCollection?
#       I think it will replace it. We still have to code something that
#       caches whole collections though.

CachedReadOnlyModel = Backbone.Model.extend({})
# We override extend so that we can add static methods to the class
CachedReadOnlyModel.extend = (args...) ->
  clazz = Backbone.Model.extend.apply(@, args)
  _.extend clazz,
    find: (id) ->
      if(x = (@_cache and @_cache[id]))
        return x
      else
        throw "Cannot find model ##{id}!"
    add_to_cache: (model) ->
      @_cache ||= {}
      @_cache[model.id] = model
  return clazz

CachedReadOnlyCollection = Backbone.Collection.extend
  fetch: (opts = {}) ->
    {success} = opts
    opts.success = (args...)=>
      @model.add_to_cache(x) for x in @models
      success(args...) if success
    # Is this right?
    Backbone.Collection::fetch.call(@, opts)
