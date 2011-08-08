FormHelpers =
  label_tag: (id, text) -> "<label for='#{id}'>#{text}</label>"
  text_field_tag: (id) -> "<input type='text' id='#{id}' name='#{id}'></input>"
  check_box_tag: (id) -> "<input type='checkbox' id='#{id}' name='#{id}'></input>"
  text_area_tag: (id) -> "<textarea id='#{id}' name='#{id}'></textarea>"
  radio_button_tag: (name, value, checked = false) ->
    "<input type='radio' id='#{name}_#{value}'#{checked ? ' checked="checked"' : ''} name='#{name}'></input>"

# Aliases
FormHelpers.label_for = FormHelpers.label_tag
FormHelpers.checkbox_tag = FormHelpers.check_box_tag


# Wrap template functions to automatically include form helper functions as locals
(->
  wrapum = (ob) ->
    _.each _.keys(ob), (k) ->
      if _.isFunction(ob[k])
        old = ob[k]
        ob[k] = (arg = {}) ->
          arg = _.extend(_.clone(FormHelpers), arg)
          old(arg)
      else
        wrapum(ob[k])
  wrapum(Templates))()
