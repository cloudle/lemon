Apps.Merchant.importInit.push (scope) ->
  logics.import.createNewProvider = (event, template)->
    name    = template.find(".name").value
    phone   = template.find(".phone").value
    address = template.find(".address").value

    result = Provider.createNew(name, phone, address)
    if result.error
      console.log result.error
    else
      template.find(".name").value = null
      template.find(".address").value = null
      template.find(".phone").value = null

  logics.import.removeNewProvider = (providerId)->
    result = Provider.destroyByCreator(providerId)
    if result.error then console.log result.error