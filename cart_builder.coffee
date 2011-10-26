CartBuilder =
  create_cart: (model) ->
    cv = new CartView(model: model)

    unless $('.right #services').length
      unless Bootstrapper.current instanceof CatalogView
        $('.right').prepend("<img src=\"images/back_to_catalog.png\" class=\"return-to-catalog\">")

      $('.right').prepend(cv.render().el)

    if model.line_items.length > 0
      services = model.services()

      # Attach the services to the line_items and trigger event so the cartview
      # will show them
      success = =>
        $('.right #services #my_services').empty()
        model.line_items.each (line_item) ->
          line_item.service = services.get(line_item.get('service_id'))
          CartBuilder.add_line_item(line_item, model)

        # add striping to cart items
        odd = false
        $('#my_services div.line_item').each( ->
          $(@).addClass('odd') if odd
          odd = !odd
          return @
        )

        return @
      services.fetch(success: success)
    else
      $('.right #services #my_services').empty()

  add_line_item: (li, service_request) ->
    civ = new CartItemView(model: li, service_request: service_request)
    $('#my_services').append(civ.render().el)

  remove_line_item: (li, service_request) ->
    as = li.service.associated_services()

    wait_for_me = =>
      if as.length > 0
        _.each as.models, (a_service) =>
          if a_li = (li.collection.detect((li) -> li.service.id == a_service.get('service_id')))
            a_li.attributes['optional'] = 'true'
      li.collection.remove(li)
      service_request.save({}, success: => CartBuilder.create_cart(service_request))

    as.fetch(success: wait_for_me)
