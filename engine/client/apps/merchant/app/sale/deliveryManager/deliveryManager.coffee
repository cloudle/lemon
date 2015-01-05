lemon.defineApp Template.deliveryManager,
  activeDeliveryFilter: (status)-> return 'active' if Session.get('deliveryFilter') is status
  events:
    "click [data-filter]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'deliveryFilter', $element.attr("data-filter")

