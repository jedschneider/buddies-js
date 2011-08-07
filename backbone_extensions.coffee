Sparkles = {}
Sparkles.Model = Backbone.Model.extend
  set: (atts, options) ->
    if(@attribute_types)
      for k,v of atts
        if(@attribute_types[k] == 'integer')
          atts[k] = parseInt(atts[k])
    _.bind(Backbone.Model.prototype.set, @)(atts, options)

Sparkles.View = Backbone.View.extend
  # Calls the supplied template with the form helpers copied into the object
  # so they can be accessed from the template as locals
  template_helpers: (template, ob = {}) ->
    ob = _.extend(_.clone(FormHelpers), ob)
    template(ob)
