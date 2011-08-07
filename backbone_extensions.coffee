Sparkles = {}
Sparkles.Model = Backbone.Model.extend
  set: (atts, options) ->
    if(@attribute_types)
      for k,v of atts
        if(@attribute_types[k] == 'integer')
          atts[k] = parseInt(atts[k])
    _.bind(Backbone.Model.prototype.set, @)(atts, options)
