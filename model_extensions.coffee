# {"requires": ["extensions/backbone_extender"]}

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
  init = klazz::initialize
  klazz::initialize = (atts, opts) ->
    save_atts @
    init.call @, atts, opts
  fetch = klazz::fetch
  klazz::fetch = (opts = {}) ->
    success = (opts.success or ->)
    opts.success = (args...) =>
      save_atts @
      success(args...)
    fetch.call(@, opts)
  save = klazz::save
  klazz::save = (atts, opts = {}) ->
    success = (opts.success or ->)
    opts.success = (args...) =>
      save_atts @
      success(args...)
    save.call(@, atts, opts)
  klazz::hasUnpersistedChanges = ->
    not _.isEqual @toJSON(), @_serverAttributes
