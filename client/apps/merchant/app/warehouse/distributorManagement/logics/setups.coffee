resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")
Apps.Merchant.distributorManagementInit.push (scope) ->
  Session.set("distributorManagementCurrentDistributor", Schema.distributors.findOne())

  scope.checkAllowCreateDistributor = (context) ->
    $name = context.ui.$name
    if $name.val().length > 0
      if _.findWhere(Session.get("distributorManagementCurrentDistributor"), {name: $name.val()})
        Session.set('allowCreateDistributor', false)
      else Session.set('allowCreateDistributor', true)
    else Session.set('allowCreateDistributor', false)

  scope.createDistributor = (context)->
    $name    = context.ui.$name
    $phone   = context.ui.$phone
    $address = context.ui.$address

    result = Distributor.createNew($name.val(), $phone.val(), $address.val())
    if result.error then $name.notify(result.error, {position: "bottom"})
    else Session.set('allowCreateDistributor', false)