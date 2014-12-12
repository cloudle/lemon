scope = logics.staffManagement

lemon.defineWidget Template.staffManagementCustomSaleDetails,
  customSaleDetails: ->
    customSaleId = UI._templateInstance().data._id
    Schema.customSaleDetails.find({customSale: customSaleId})
  latestPaids: -> Schema.transactions.find {latestSale: @_id}, {sort: {'version.createdAt': 1}}
  receivableClass: -> if @debtBalanceChange >= 0 then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'

  isCustomSaleModeEnabled: ->
    staff = Session.get("staffManagementCurrentStaff")
    if @allowDelete and staff?.customSaleModeEnabled then true else false

  isCustomSaleDetailCreator: ->
    staff = Session.get("staffManagementCurrentStaff")
    latestCustomSale = Schema.customSales.findOne({buyer: staff._id}, {sort: {debtDate: -1}})
    if staff?.customSaleModeEnabled and @_id is latestCustomSale?._id then true else false


  events:
    "click .enter-edit" : (event, template) -> Session.set("staffManagementCurrentCustomSale", @)
    "click .cancel-edit": (event, template) -> Session.set("staffManagementCurrentCustomSale")

    "click .deleteCustomSale": (event, template) ->   Meteor.call('deleteCustomSale', @_id)
    "click .deleteCustomSaleDetail": (event, template) -> scope.deleteCustomSaleDetail(@_id)
    "click .deleteTransaction": (event, template) -> scope.deleteTransactionCustomSale(@_id)

lemon.defineWidget Template.staffManagementCustomSaleDetailCreator,
  rendered: ->
    if $(@find("[name='price']"))
      $(@find("[name='price']")).inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11}

    if $(@find("[name='totalPrice']"))
      $(@find("[name='totalPrice']")).inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11}

  events:
    "click .createCustomSaleDetail": (event, template) -> scope.createCustomSaleDetail(@, template)
    "keypress input": (event, template) ->
      if event.which is 13 #ENTER
        scope.createCustomSaleDetail(@, template)
      else if event.which is 27
        $(template.find("[name='productName']")).val('')
        $(template.find("[name='price']")).val('')
        $(template.find("[name='quality']")).val('')
        $(template.find("[name='skulls']")).val('')