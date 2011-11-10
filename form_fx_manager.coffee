# FormFxManager : because who doesn't need a little bit of visual Fx in their form?
# 
# This namespace handles the display state of dependent inputs through a map of
# dependencies.
# Then you can declare stuff instead of writing jQuery til the cows come home.
#
# Use Case:
# In a view declare a map of dependencies.
# For checkboxes, the key should be a string of 'true' or 'false'
# For select tags, the key should be the option value to be selected
# FIXME: to be implemented:
# For text boxes, the key should be 'true' or 'false' which defines presence or no presence
#
# Example:
# visual_deps : {'foo' : {
#                 'true' : ['bar', 'baz']
#                ,'false' : ['raz']}
#               ,'baz' : {'scary' : 'boo'}}
#
# In this case, when 'foo' (either a checkbox or a textfield, it doesn't matter) is
# either selected or some text is entered, the inputs 'bar' and 'baz' will be
# visible. Clearing the field or unchecking the box will hide those fields, but
# will show 'raz'. When 'foo' is checked, the manager knows that 'baz' (a select
# tag with an option 'scary') also has a dependency but will wait for the selected
# option of 'baz' to be selected before showing the dependent input 'boo'.
#___________________________________________________________________________________

FormFxManager =
  registerListeners : (el, atts)->
    inputs = _.memoize((key) -> SparkleUtils.getInput(el, key))

    _.each _.keys(atts), (key) ->

      hide_deps = (key) ->
        vals = atts[key]
        dependents = _.union(_.values(atts[key])...)
        _.each dependents, (d) ->
          inputs(d).hide()
          if atts[d]
            hide_deps(d)

      refresh_deps = (key)->
        vals = atts[key]
        dependents = _.union(_.values(atts[key])...)
        val = FormFxManager.getValue( inputs(key) )
        should_be_visible = vals[val]
        should_be_hidden = _.difference dependents, vals[val]

        _.each should_be_visible, (d)->
          inputs(d).show()
          if atts[d]
            refresh_deps(d)
        _.each should_be_hidden, (d)->
          inputs(d).hide()
          if atts[d]
            hide_deps(d)

      # change handler
      inputs(key).change -> refresh_deps(key)
      refresh_deps(key)

  getValue: (input)->
    if input.is(':checkbox')
      if input.is(':checked') then 'true' else 'false'
    else if input[0].tagName == "SELECT"
      input.find("option:selected").val()
    else
      input.val()
