lemon.defineWidget Template.addArea,
  allowDelete: -> true
#    if Schema.customerAreas.findOne({
#      parentMerchant: Session.get('myProfile').parentMerchant
#    }) then false else true
  events:
    'click .create-area': (event, template)-> logics.customerManager.createCustomerArea(event, template)
    'click .delete-area': (event, template)-> logics.customerManager.destroyCustomerArea(@_id)



