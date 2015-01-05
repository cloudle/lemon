scope = logics.staffManagement

lemon.defineHyper Template.staffManagementSalesHistorySection,
  showExpandSaleAndCustomSale: -> Session.get("showExpandSaleAndCustomSale")
  finalDebtBalance: -> @customSaleDebt + @saleDebt
  allowCreateCustomSale: -> if Session.get("allowCreateCustomSale") then '' else 'disabled'
  allowCreateTransactionOfSale: -> if Session.get("allowCreateTransactionOfSale") then '' else 'disabled'
  allowCreateTransactionOfCustomSale: -> if Session.get("allowCreateTransactionOfCustomSale") then '' else 'disabled'

  showIsFoundSale: -> if Schema.sales.find({buyer: Session.get("staffManagementCurrentStaff")?._id}).count() > 0 then "" else "display: none;"
  isCustomSaleModeEnabled: -> if Session.get("staffManagementCurrentStaff")?.customSaleModeEnabled then "" else "display: none;"

  customSale: -> Schema.customSales.find({buyer: Session.get("staffManagementCurrentStaff")?._id}, {sort: {debtDate: 1}})
  defaultSale: -> Schema.sales.find({buyer: Session.get("staffManagementCurrentStaff")?._id}, {sort: {'version.createdAt': -1}})
  defaultSaleArchive: -> Schema.sales.find {
      buyer               : Session.get("staffManagementCurrentStaff")?._id,
      'version.createdAt' : {$lt: new Date((new Date).toDateString())}
    }, {sort: {'version.createdAt': 1}}
  defaultSaleToday: -> Schema.sales.find {
      buyer               : Session.get("staffManagementCurrentStaff")?._id,
      'version.createdAt' : {$gte: new Date((new Date).toDateString())}
    }, {sort: {'version.createdAt': 1}}

  rendered: ->
    @ui.$debtDate.inputmask("dd/mm/yyyy")
    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$paidDate.inputmask("dd/mm/yyyy")

    @ui.$paySaleAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandSaleAndCustomSale": ->
      if staff = Session.get("staffManagementCurrentStaff")
        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
        if staff.customSaleModeEnabled
          currentRecords = Schema.customSales.find({buyer: staff._id}).count()
        else
          currentRecords = Schema.customSales.find({buyer: staff._id}).count() + Schema.sales.find({buyer: staff._id}).count()
        Meteor.subscribe('staffManagementData', staff._id, currentRecords, limitExpand)
        Session.set("staffManagementDataMaxCurrentRecords", currentRecords + limitExpand)

    "click .customSaleModeDisable":  (event, template) ->
      scope.customSaleModeDisable(staff._id) if staff = Session.get("staffManagementCurrentStaff")

#----Create-Transaction-Of-CustomSale-----------------------------------------------------------------------
    "keydown input.new-bill-field.number": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        scope.checkAllowCreateCustomSale(template, staff) if event.which is 8

    "click .createCustomSale":  (event, template) ->
      scope.createCustomSale(template) if Session.get("allowCreateCustomSale")

    "keypress input.new-bill-field": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        scope.checkAllowCreateCustomSale(template, staff)
        scope.createCustomSale(template) if event.which is 13 and Session.get("allowCreateCustomSale")

#----Create-Transaction-Of-CustomSale-----------------------------------------------------------------------
    "keydown .new-transaction-custom-sale-field": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        scope.checkAllowCreateTransactionOfCustomSale(template, staff) if event.which is 8

    "click .createTransactionOfCustomSale": (event, template) ->
      scope.createTransactionOfCustomSale(template) if Session.get("allowCreateTransactionOfCustomSale")

    "keypress input.new-transaction-custom-sale-field": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        scope.checkAllowCreateTransactionOfCustomSale(template, staff)
        scope.createTransactionOfCustomSale(template) if event.which is 13 and Session.get("allowCreateTransactionOfCustomSale")

#----Create-Transaction-Of-Sale-----------------------------------------------------------------------
    "keydown .new-transaction-custom-sale-field": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        scope.checkAllowCreateTransactionOfSale(template, staff) if event.which is 8

    "click .createTransactionOfSale": (event, template) ->
      scope.createTransactionOfSale(template) if Session.get("allowCreateTransactionOfSale")

    "keypress input.new-transaction-sale-field": (event, template) ->
      if staff = Session.get("staffManagementCurrentStaff")
        scope.checkAllowCreateTransactionOfSale(template, staff)
        scope.createTransactionOfSale(template) if event.which is 13 and Session.get("allowCreateTransactionOfSale")
