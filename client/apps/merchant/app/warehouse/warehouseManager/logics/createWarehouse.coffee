resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")

logics.warehouseManager.createWarehouse = (context) ->
  name = context.ui.$name.val()
  address = context.ui.$address.val()

  option=
    parentMerchant    : Session.get('myProfile').parentMerchant
    merchant          : Session.get('myProfile').currentMerchant
    creator           : Session.get('myProfile').user
    name              : name
    isRoot            : false
    checkingInventory : false
  option.location = {address: [address]} if address

  Schema.warehouses.insert option, (error, result)->
    if error then console.log error
    else
      MetroSummary.updateMetroSummaryBy(['warehouse'])
      Session.set('allowCreateNewWarehouse', false)
      resetForm(context)

