# {"requires": ["extensions/underscore_extensions"]}

# Add an extensions API to the four Backbone classes.
#
# API is, for example with models:
#
#   Backbone.Model.define_extension "foo", (klazz, props) ->
#     # here you have the newly defined class object and can
#     # muck with it to make it do what you want. The second
#     # argument allows customization.
#     # Use klazz.method = to set class methods and
#     #     klass::method = to set instance methods
#
#   Backbone.Model.undefine_extension "foo"
#
# Then to use a defined extension,
#
#   FooHaver = Backbone.Model.extend
#     extensions:
#       foo: true  # the value here is what gets passed to the
#                  # extender function as the 'props' arg
_.each [Backbone.Model, Backbone.Collection, Backbone.View, Backbone.Router], (bb_class) ->
  defined_extensions = []
  bb_class.define_extension = (extension_name, fn) ->
    if _.any(defined_extensions, ([en, fn]) -> en == extension_name)
      throw "Extension #{JSON.stringify extension_name} already defined!"
    defined_extensions.push [extension_name, fn]
  bb_class.undefine_extension = (extension_name) ->
    defined_extensions = _.reject defined_extensions, ([en, fn]) -> en == extension_name
  # FIXME: I'm not sure if this will work when there is a superclass and a subclass
  # and they both declare extensions?
  _.wrapMethod bb_class, 'extend', (old_extend, methods, class_methods) ->
    exts = null
    if exts = methods.extensions
      delete methods.extensions
    klazz = old_extend(methods, class_methods)
    if exts
      _.each defined_extensions, ([ex_name, fn]) ->
        if _.hasKey(exts, ex_name)
          fn(klazz, exts[ex_name])
          delete exts[ex_name]
      if non_existent_extension = _.keys(exts)[0]
        throw "Unknown model extension #{JSON.stringify(non_existent_extension)}"
    return klazz