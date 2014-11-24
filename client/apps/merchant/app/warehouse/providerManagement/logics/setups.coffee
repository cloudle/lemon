Apps.Merchant.providerManagementInit.push (scope) ->
  Session.set("providerManagementCurrentProvider", Schema.providers.findOne())