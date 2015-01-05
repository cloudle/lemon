Apps.Merchant.importInit.push (scope) ->
  logics.import.createNewDistributor = (event, template)->
    name    = template.find("[name=name]").value
    phone   = template.find("[name=phone]").value
    address = template.find("[name=address]").value

    option =
      parentMerchant: Session.get('myProfile').parentMerchant
      merchant      : Session.get('myProfile').currentMerchant
      creator       : Session.get('myProfile').user
      name          : name
      phone         : phone
      location      : {address: [address]}

    result = Schema.distributors.insert option, (error, result)-> if error then {error: error} else {}
    if result.error
      console.log result.error
    else
      template.find("[name=name]").value    = null
      template.find("[name=phone]").value   = null
      template.find("[name=address]").value = null

  logics.import.removeNewDistributor = (distributorId)->
    distributor = Schema.distributors.findOne({_id: distributorId , creator: Meteor.userId()})
    if distributor.allowDelete then Schema.distributors.remove(distributorId)
