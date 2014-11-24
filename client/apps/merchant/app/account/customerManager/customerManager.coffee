lemon.defineApp Template.customerManager,
#      $companyName = $(template.find("#companyName"))
#      if $companyName.val().length > 0
#        Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: {companyName: $companyName.val()}
#      else
#        $companyName.notify('tên công ty không được để trống', {position: "right"})
#
#    "blur #companyPhone" : (event, template) ->
#      $companyPhone = $(template.find("#companyPhone"))
#      if $companyPhone.val().length > 0
#        Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: {companyPhone: $companyPhone.val()}
#      else
#        $companyPhone.notify('số điện thoại không được để trống!', {position: "right"})
#
#    "blur #merchantName" : (event, template) ->
#      $merchantName = $(template.find("#merchantName"))
#      if $merchantName.val().length > 0
#        Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: {merchantName: $merchantName.val()}
#      else
#        $merchantName.notify('tên chi nhánh không được để trống!', {position: "right"})
#
#    "blur #warehouseName": (event, template) ->
#      $warehouseName = $(template.find("#warehouseName"))
#      if $warehouseName.val().length > 0
#        Schema.merchantPackages.update Session.get("merchantPackages")._id, $set: {warehouseName: $warehouseName.val()}
#      else
#        $warehouseName.notify('tên kho hàng không để trống!', {position: "right"})
  created: ->
    Session.setDefault('allowCreateNewCustomer', false)

  events:
    "input input": (event, template) -> logics.customerManager.checkAllowCreate(template)
    "change [name='advancedMode']": (event, template) -> Session.set 'genderNewCustomer123', event.target.checked
    "click .add-area": (event, template) -> $(template.find '#addArea').modal()

    "click #createCustomerAccount": (event, template) -> logics.customerManager.createNewCustomer(template)

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
              console.log file, results
              logics.customerManager.importFileCustomerCSV(results.data)

        $excelSource.val("")