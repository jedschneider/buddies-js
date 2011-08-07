FormHelpers =
  label_tag: (id, text) -> "<label for='#{id}'>#{text}</label>"
  text_field_tag: (id) -> "<input type='text' id='#{id}' name='#{id}'></input>"
  check_box_tag: (id) -> "<input type='checkbox' id='#{id}' name='#{id}'></input>"
  text_area_tag: (id) -> "<textarea id='#{id}' name='#{id}'></textarea>"
FormHelpers.label_for = FormHelpers.label_tag
FormHelpers.checkbox_tag = FormHelpers.check_box_tag
