# First provide an extension mechanism to Backbone.Model
#
# API is
#
#   Backbone.Model.define_extension "foo", (klazz, props) ->
#     # here you have the newly defined class object and can
#     # muck with it to make it do what you want. The second
#     # argument allows customization.
#
#   Backbone.Model.undefine_extension "foo"
#
# Then to use a defined extension,
#
#   FooHaver = Backbone.Model.extend
#     extensions:
#       foo: true  # the value here is what gets passed to the
#                  # extender function as the 'props' arg

(->
  old_extend = Backbone.Model.extend
  defined_extensions = []
  Backbone.Model.define_extension = (extension_name, fn) ->
    if _.any(defined_extensions, ([en, fn]) -> en == extension_name)
      throw "Extension #{JSON.stringify extension_name} already defined!"
    defined_extensions.push [extension_name, fn]
  Backbone.Model.undefine_extension = (extension_name) ->
    defined_extensions = _.reject defined_extensions, ([en, fn]) -> en == extension_name
  Backbone.Model.extend = (methods, class_methods) ->
    exts = null
    if exts = methods.extensions
      delete methods.extensions
    klazz = old_extend.call Backbone.Model, methods, class_methods
    if exts
      _.each defined_extensions, ([ex_name, fn]) ->
        if _.hasKey(exts, ex_name)
          fn(klazz, exts[ex_name])
    return klazz
)()
