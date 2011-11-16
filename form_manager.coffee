# FormManager
# Intends to take the complexity out of applying values from an
# object into the values for a form, and then pulling those values back out
# for persistance or change.
#
# Expects two parameters:
# 1) @el as a jquery selector
# 2) @atts as a map from keys on the object to html selector/name/etc
#
# @atts may be in two forms, either as a simple map with a pointer
# from the model_attribute to a DOM selector or as a complex map from
# a model attribute to a map of options:
#
# Optionally, the 'require_visible' key can be added to the more complex map,
# that will verify the input is in a visible state before passing the key,
# this is largely designed to be programatically added to the map if you want
# to be able to make the form smart about which keys to set and unset
# before persisting to the db.
#
# atts = {"short_title" : "short-title"}
#
# atts = { short_title : {selector : "short-title", require_visible : true}}
#
#
# Public API
#
# FormManager.populateForm(object, el, atts)
# FormManager.extract(el, atts)
#_________________________________________________________________________
FormManager =

  populateForm : (ob, el, atts)->
    _.each _.keys(atts), (key) =>
      # normalize the default case to a map
      @el = el
      val = atts[key]
      if _.isString val
        val = {selector : val}
      selector = @detectSelector val
      input = @getInput(selector)
      value = ob[key]
      if input.is(':checkbox')
        input.prop('checked', value)
      if input.is(':text')
        input.val value
      if input[0].tagName == "SELECT"
        input.find("option[value='#{value}']").prop("selected", true)

  extract: (el, atts)->
    @el = el
    ob = {}
    _.each _.keys(atts), (key)=>
      selector = @detectSelector atts[key]
      require_visible = atts[key]['require_visible']
      input = @getInput(selector)
      # the attribute is defined by the map to only be saved if it is visible
      # or it is defined by the map to capture the attribute in either visible state
      if (require_visible and input.is(':visible'))  or  !require_visible
        if input.is(':text')
          value = input.val()
        if input.is(':checkbox')
          value = input.is(":checked")
        if input[0].tagName == "SELECT"
          value = input.find("option:selected").val()
        ob[key] = value
    ob

  # FIXME: swapout for the same method in sparkle utils
  getInput: (selector)->
    [garbage, class_name, selector_id, name] = selector.match /(^\..*)|(^\#.*)|(^.*)/
    if name
      input = $(@el).find(":input[name='#{name}']")
    else
      input = $(@el).find(":input#{class_name or selector_id}")
    assert input and (input.length > 0), "FormManager#getInput could not find an element to match the key #{selector}"
    input

  # this will probably get hairy at some point
  detectSelector: (value)->
    value['selector']
