scope = logics.customerManagement

lemon.defineWidget Template.customerManagementCustomSaleDetails,
  isNotPaid: -> !@paid
  isEditing: -> Session.get("customerManagementCurrentCustomSale")?._id is @_id
  customSaleDetails: ->
    customSaleId = UI._templateInstance().data._id
    Schema.customSaleDetails.find({customSale: customSaleId})

  events:
    "click .enter-edit" : (event, template) -> Session.set("customerManagementCurrentCustomSale", @)
    "click .cancel-edit": (event, template) -> Session.set("customerManagementCurrentCustomSale")
    "click .createCustomSaleDetail": (event, template) -> scope.createCustomSaleDetail(@, template)
    "click .deleteCustomSaleDetail": (event, template) -> scope.deleteCustomSaleDetail(@_id) 
    "click .paid-customSale": (event, template) -> scope.paidCustomSale(@_id)