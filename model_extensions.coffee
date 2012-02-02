# {"requires": ["extensions/backbone_extender",
#               "extensions/underscore_extensions",
#               "utils"]}

# Oddly enough it seems Backbone doesn't track whether
# a model has changed since it was last synced with the
# server, only if it has changed since the last time a
# change event was fired, which has pretty limited use
# as far as I can tell.
#
# This adds one instance method to models:
#   Model#hasUnpersistedChanges  => returns a boolean
#
# They work by storing a copy of the attributes at three
# points: after the constructor runs (before your initialize
# function is called), after a successful fetch (before
# your success callback is called), and after a successful
# save (before your success callback is called).
#
# Does not have any customization options.
Backbone.Model.define_extension "unpersisted_changes", (klazz) ->
  save_atts = (model) ->
    model._serverAttributes = _.deepClone model.toJSON()
  klazz::initialize = (atts, opts) ->
  _.wrapMethod klazz::, 'initialize', (old_init, atts, opts) ->
    save_atts @
    old_init(atts, opts)
  _.wrapMethod klazz::, 'fetch', (old_fetch, opts = {}) ->
    success = (opts.success or ->)
    opts.success = (args...) =>
      save_atts @
      success(args...)
    old_fetch(opts)
  _.wrapMethod klazz::, 'save', (old_save, atts, opts = {}) ->
    success = (opts.success or ->)
    opts.success = (args...) =>
      save_atts @
      success(args...)
    old_save(atts, opts)
  klazz::hasUnpersistedChanges = ->
    not _.isEqual @toJSON(), @_serverAttributes


# The Service Catalog is read-only for this app, and we gain a lot of
# simplicity by caching it. Is stale data bad? What's the worst that can happen
# when somebody updates the service catalog and we don't see it right away?

Backbone.Model.define_extension 'cached', (klazz) ->
  class_name = klazz::class_name
  _.extend klazz,
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
    # Useful just for testing I guess
    clear_cache: ->
      @_cache = {}

Backbone.Collection.define_extension 'cached', (klazz, {fetch_once}) ->
  model = klazz::model
  probably = (model.find and model.does_cache_contain and model.add_to_cache)
  assert(probably, "Collections extended with 'cached' must have their models extended with 'cached'!")

  _.wrapMethod klazz::, 'fetch', (func, opts = {}) ->
    {success} = opts
    opts.success = (args...) =>
      @model.add_to_cache(x) for x in @models
      success(args...) if success
    func(opts)

  if fetch_once
    # Wrapping the wrapper woohoo what fun
    _.wrapMethod klazz::, 'fetch', (func, opts = {}) ->
      success = (opts.success or ->)
      if @_fetched
        _.defer =>
          @trigger 'reset'
          success()
      else
        opts.success = =>
          @_fetched = true
          success()
        func(opts)

Backbone.Collection.define_extension 'ordered_by_attribute', (klazz) ->
  klazz::comparator = (model) -> (model.get('order') || 99999)

# Argument should be a method name. This method will be called after
# a successful fetch, and will be given the user supplied callback
# as its first argument (i.e., it is expected that you will call the
# callback yourself at some point).
Backbone.Model.define_extension 'fetch_hook', (klazz, m_name) ->
  _.wrapMethod klazz::, 'fetch', (old_fetch, opts) ->
    success = opts.success or ->
    opts.success = (args...) =>
      @[m_name]((-> success(args...)), args...)
    old_fetch(opts)
