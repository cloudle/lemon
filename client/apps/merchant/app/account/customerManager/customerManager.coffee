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

    "click .excel-customer": (event, template) -> $(".excelFileSource").click()
    "change .excelFileSource": (event, template) ->
      if event.target.files.length > 0
        console.log 'importing'
        $excelSource = $(".excelFileSource")
        $excelSource.parse
          config:
            complete: (results, file) ->
              if file.type is "text/csv"
                console.log results.data
#                Apps.Merchant.exportFileCustomer(results.data)

        $excelSource.val("")