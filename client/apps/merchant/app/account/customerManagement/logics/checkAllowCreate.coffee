Apps.Merchant.customerManagementInit.push (scope) ->
  scope.checkAllowCreate = (context) ->
    fullName = context.ui.$fullName.val()
    description = context.ui.$description.val()

    if fullName.length > 0 #and description.length > 0
      option =
        name: fullName
        description: description if description.length > 0

      if _.findWhere(Session.get("availableCustomers"), option)
        Session.set('allowCreateNewCustomer', false)
      else
        Session.set('allowCreateNewCustomer', true)
    else
      Session.set('allowCreateNewCustomer', false)


  formatPaymentMethodSearch = (item) -> "#{item.display}" if item
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