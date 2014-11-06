lemon.defineApp Template.customerManager,
  created: ->
    Session.setDefault('allowCreateNewCustomer', false)
    Session.setDefault('genderNewCustomer', true)

  events:
    "input input": (event, template) -> logics.customerManager.checkAllowCreate(template)
    "click #createCustomerAccount": (event, template) -> logics.customerManager.createNewCustomer(template)
    "change [name='genderMode']": (event, template) -> Session.set 'genderNewCustomer', event.target.checked
    "click .thumbnails": (event, template) ->
#      Meteor.subscribe('saleAndReturnDetails', @_id)
#      Session.set('currentBillManagerSale', @)
      $(template.find '#customerProfileManager').modal()