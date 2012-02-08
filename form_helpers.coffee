FormHelpers =
  # ID is ignored. Present in arg-list so signature matches Rails.
  label_tag: (id, text) -> "<label>#{text}</label>"
  text_field_tag: (name, class_name="") ->
    className = if class_name.length > 0 then class_name else name
    "<input type='text' class='#{className}' name='#{name}'></input>"
  check_box_tag: (name, checked=false) ->
    if checked
      "<input type='checkbox' class='#{name}' name='#{name}' checked='checked'></input>"
    else
      "<input type='checkbox' class='#{name}' name='#{name}'></input>"
  text_area_tag: (name) -> "<textarea class='#{name}' name='#{name}'></textarea>"
  radio_button_tag: (name, value, checked = false) ->
    "<input type='radio'#{if checked then ' checked="checked"' else ''} class='#{name}' name='#{name}' value='#{value}'></input>"

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
