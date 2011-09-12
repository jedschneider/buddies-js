CartBuilder =
  load_existing_services: (model) ->
    if model.line_items.length > 0
      services = model.services()
      
      # Attach the services to the line_items and trigger event so the cartview
      # will show them
      success = =>
        model.line_items.each (line_item) ->
          line_item.service = services.get(line_item.get('service_id'))
        model.line_items.trigger('services_attached')

      services.fetch(success: success)