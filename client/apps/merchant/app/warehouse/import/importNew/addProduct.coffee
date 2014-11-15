lemon.defineWidget Template.addProduct,
  allowDelete: ->
    if Schema.importDetails.findOne({
      product: @_id
      merchant: Session.get('myProfile').currentMerchant
    }) then false else true
  events:
    'click .create-product': (event, template)-> logics.import.createNewProduct(event, template)
    'click .delete-product': (event, template)-> logics.import.destroyNewProduct(@_id)



