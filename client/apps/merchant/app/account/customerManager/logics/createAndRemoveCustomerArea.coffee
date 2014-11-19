Apps.Merchant.customerManagerInit.push (scope) ->
  scope.createCustomerArea = (event, template)->
    name        = $("[name=areaName]").val()
    description = $("[name=areaDescription]").val()

    if name.length > 0
      option =
        parentMerchant: Session.get('myProfile').parentMerchant
        creator       : Session.get('myProfile').user
        name          : name
        description   : description

      if Schema.customerAreas.insert option
        $("[name=areaName]").val("")
        $("[name=areaDescription]").val("")

  scope.destroyCustomerArea = (customerAreaId)->
    result = CustomerArea.destroyByCreator(customerAreaId)
    if result.error then console.log result.error