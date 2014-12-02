Apps.Merchant.customerManagementInit.push (scope) ->
  scope.checkAllowCreate = (context) ->
    fullName = context.ui.$fullName.val()
    description = context.ui.$description.val()
    if fullName.length > 0
      option =
        name: fullName
        description: description if description.length > 0
      if _.findWhere(Session.get("availableCustomers"), option) then Session.set('allowCreateNewCustomer', false)
      else Session.set('allowCreateNewCustomer', true)
    else Session.set('allowCreateNewCustomer', false)

  scope.checkAllowCreateTransactionOfCustomSale = (template, customer)->
    latestCustomSale = Schema.customSales.findOne({buyer: customer._id}, {sort: {debtDate: -1}})

    payAmount = parseInt($(template.find("[name='payAmount']")).inputmask('unmaskedvalue'))
    paidDate  = moment(template.ui.$paidDate.val(), 'DD/MM/YYYY')._d
    currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())

    if latestCustomSale is undefined || currentPaidDate >= latestCustomSale?.debtDate and !isNaN(payAmount)
      Session.set("allowCreateTransactionOfCustomSale", true)
    else
      Session.set("allowCreateTransactionOfCustomSale", false)
