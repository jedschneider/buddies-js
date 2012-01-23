CartBuilder =
  create_cart: (model) ->
    cv = new CartView(model: model)

    unless $('.right #services').length
      unless app.view.current instanceof CatalogView
        $('.right').prepend("<img src=\"images/back_to_catalog.png\" class=\"return-to-catalog\">")

      $('.right').prepend(cv.render().el)

    if model.line_items.length > 0
      services = model.line_items.invoke('service')

      # Attach the services to the line_items and trigger event so the cartview
      # will show them
      $('.right #services #my_services').empty()
      model.line_items.each (line_item) ->
        CartBuilder.add_line_item(line_item, model)

      @restripe()

      return @
    else
      $('.right #services #my_services').empty()

  restripe: ->
    odd = false
    $('#my_services div.line_item').each( ->
      if odd
        $(@).addClass('odd')
      else
        $(@).removeClass('odd')
      odd = !odd
      return @
    )

  add_line_item: (li, service_request) ->
    civ = new CartItemView(model: li, service_request: service_request)
    $('#my_services').append(civ.render().el)
    @restripe()

  remove_line_item: (li, service_request) ->
    sas = li.service().service_associations()

    wait_for_me = =>
      sas.each (association) =>
        if a_li = (li.collection.detect((li) -> li.service().id == association.get('service_id')))
          a_li.attributes['optional'] = true
      li.collection.remove(li)
      service_request.save({}, success: => CartBuilder.create_cart(service_request))

    sas.fetch(success: wait_for_me)