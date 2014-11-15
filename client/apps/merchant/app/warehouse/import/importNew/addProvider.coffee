lemon.defineWidget Template.addProvider,
  allowDelete: ->
    if Schema.importDetails.findOne({
      provider: @_id
      merchant: Session.get('myProfile').currentMerchant
#      parentMerchant: Session.get('myProfile').parentMerchant
    }) then false else true

  events:
    'click .create-provider': (event, template)-> logics.import.createNewProvider(event, template)
    'click .delete-provider': (event, template)-> logics.import.removeNewProvider(@_id)



