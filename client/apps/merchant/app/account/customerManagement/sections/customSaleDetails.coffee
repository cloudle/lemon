scope = logics.customerManagement

lemon.defineWidget Template.customerManagementCustomSaleDetails,
  customSaleDetails: ->
    customSaleId = UI._templateInstance().data._id
    Schema.customSaleDetails.find({customSale: customSaleId})
  latestPaids: -> Schema.transactions.find {latestSale: @_id}, {sort: {'version.createdAt': 1}}
  receivableClass: -> if @debtBalanceChange >= 0 then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'

  events:
    "click .enter-edit" : (event, template) -> Session.set("customerManagementCurrentCustomSale", @)
    "click .cancel-edit": (event, template) -> Session.set("customerManagementCurrentCustomSale")
    "click .deleteCustomSale": (event, template) ->   Meteor.call('deleteCustomSale', @_id)
    "click .deleteCustomSaleDetail": (event, template) -> scope.deleteCustomSaleDetail(@_id)

lemon.defineWidget Template.customerManagementCustomSaleDetailCreator,
  rendered: ->
    $(@find("[name='price']")).inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11}

  events:
    "click .createCustomSaleDetail": (event, template) -> scope.createCustomSaleDetail(@, template)
    "keypress input": (event, template) -> scope.createCustomSaleDetail(@, template) if event.which is 13 #ENTER