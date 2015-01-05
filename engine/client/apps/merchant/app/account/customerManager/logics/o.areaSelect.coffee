formatAreaSelect = (item) -> "#{item.name}" if item
formatPaymentMethodSearch = (item) -> "#{item.display}" if item

Apps.Merchant.customerManagerInit.push (scope) ->
  Session.set('currentCustomerAreaSelection', [])

  scope.areaSelectOptions =
    query: (query) -> query.callback
      results: logics.customerManager.availableCustomerAreas.fetch()
    initSelection: (element, callback) -> callback Session.get('currentCustomerAreaSelection')
    changeAction: (e) ->
      currentAreas = Session.get('currentCustomerAreaSelection')
      currentAreas = currentAreas ? []

      currentAreas.push e.added if e.added
      if e.removed
        removedItem = _.findWhere(currentAreas, {_id: e.removed._id})
        currentAreas.splice currentAreas.indexOf(removedItem), 1

      Session.set('currentCustomerAreaSelection', currentAreas)
    reactiveValueGetter: -> Session.get('currentCustomerAreaSelection')
    formatSelection: formatAreaSelect
    formatResult: formatAreaSelect
    others:
      multiple: true
      maximumSelectionSize: 3

  Session.set('genderNewCustomer', true)
  scope.genderSelectOptions =
    query: (query) -> query.callback
      results: Apps.Merchant.GenderTypes
      text: 'id'
    initSelection: (element, callback) ->
      callback _.findWhere(Apps.Merchant.GenderTypes, {_id: Session.get('genderNewCustomer')})
    reactiveValueGetter: -> _.findWhere(Apps.Merchant.GenderTypes, {_id: Session.get('genderNewCustomer')})
    changeAction: (e) ->
      Session.set('genderNewCustomer', e.added._id)
      pronoun = $("[name=pronoun]").val()
      if pronoun is "Anh" or pronoun is "Chị" or pronoun is ""
        if e.added._id then $("[name=pronoun]").val('Anh') else $("[name=pronoun]").val('Chị')
    formatSelection: formatPaymentMethodSearch
    formatResult: formatPaymentMethodSearch
    placeholder: 'CHỌN GIỚI TÍNH'
    minimumResultsForSearch: -1



