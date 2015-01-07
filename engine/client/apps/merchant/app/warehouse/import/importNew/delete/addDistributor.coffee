lemon.defineWidget Template.addDistributor,
  allowDelete: ->
    if @allowDelete
      if Schema.importDetails.findOne({
        provider: @_id
        merchant: Session.get('myProfile').currentMerchant
  #      parentMerchant: Session.get('myProfile').parentMerchant
      }) then false else true

  events:
    'click .create-distributor': (event, template)-> logics.import.createNewDistributor(event, template)
    'click .delete-distributor': (event, template)-> logics.import.removeNewDistributor(@_id)



