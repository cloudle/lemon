resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")
Apps.Merchant.providerManagementInit.push (scope) ->
  Meteor.subscribe('availablePayable')
  Session.set("providerManagementSearchFilter", "")
  Session.set("providerManagementCurrentProvider", Schema.providers.findOne())

  scope.checkAllowCreateProvider = (context) ->
    $name = context.ui.$name
    if $name.val().length > 0
      if _.findWhere(Session.get("providerManagementCurrentProvider"), {name: $name.val()})
        Session.set('allowCreateProvider', false)
      else Session.set('allowCreateProvider', true)
    else Session.set('allowCreateProvider', false)

  scope.createProvider = (context)->
    $name    = context.ui.$name
    $phone   = context.ui.$phone
    $address = context.ui.$address

    result = Provider.createNew($name.val(), $phone.val(), $address.val())
    if result.error then $name.notify(result.error, {position: "bottom"})
    else Session.set('allowCreateProvider', false)