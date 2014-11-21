Apps.Merchant.customerManagementInit.push (scope) ->
  scope.customerList = Schema.customers.find({parentMerchant: Session.get("myProfile").parentMerchant})

  scope.listingGridOptions =
    itemTemplate: 'customerListItem'
    reactiveSourceGetter: -> scope.customerList