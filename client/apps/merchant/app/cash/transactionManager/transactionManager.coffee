lemon.defineApp Template.transactionManager,
  activeReceivable: (receivable)-> return 'active' if Session.get('receivable') is receivable
  activeTransactionFilter: (filter)-> return 'active' if Session.get('transactionFilter') is filter

  events:
    "click [data-receivable]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'receivable', $element.attr("data-receivable")
    "click [data-filter]": (event, template) ->
      $element = $(event.currentTarget)
      Session.set 'transactionFilter', $element.attr("data-filter")


