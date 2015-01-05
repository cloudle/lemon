Apps.Merchant.customerManagementInit.push (scope) ->
#  scope.checkAllowCreate = (context) ->
#    fullName = context.ui.$fullName.val()
#    description = context.ui.$description.val()
#    if fullName.length > 0
#      option =
#        name: fullName
#        description: description if description.length > 0
#      if _.findWhere(Session.get("availableCustomers"), option) then Session.set('allowCreateNewCustomer', false)
#      else Session.set('allowCreateNewCustomer', true)
#    else Session.set('allowCreateNewCustomer', false)

  scope.checkAllowCreateTransactionOfCustomSale = (template, customer)->
    latestCustomSale = Schema.customSales.findOne({buyer: customer._id}, {sort: {debtDate: -1}})

    $paidDate = $(template.find("[name='paidDate']")).inputmask('unmaskedvalue')
    paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
    currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
    limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and currentPaidDate > limitCurrentPaidDate and currentPaidDate < new Date()
    payAmount = parseInt($(template.find("[name='payAmount']")).inputmask('unmaskedvalue'))

    if isValidDate and payAmount != 0 and (latestCustomSale is undefined  || currentPaidDate >= latestCustomSale?.debtDate and !isNaN(payAmount))
      Session.set("allowCreateTransactionOfCustomSale", true)
    else
      Session.set("allowCreateTransactionOfCustomSale", false)

  scope.checkAllowCreateTransactionOfSale = (template, customer)->
    payAmount = parseInt($(template.find("[name='paySaleAmount']")).inputmask('unmaskedvalue'))
    if payAmount != 0 and !isNaN(payAmount)
      Session.set("allowCreateTransactionOfSale", true)
    else
      Session.set("allowCreateTransactionOfSale", false)

#    if latestSale = Schema.sales.findOne({buyer: customer._id}, {sort: {'version.createdAt': -1}})
#      payAmount = parseInt($(template.find("[name='paySaleAmount']")).inputmask('unmaskedvalue'))
#
#      if payAmount != 0 and !isNaN(payAmount)
#        Session.set("allowCreateTransactionOfSale", true)
#      else
#        Session.set("allowCreateTransactionOfSale", false)

#      $paidDate = $(template.find("[name='paidSaleDate']")).inputmask('unmaskedvalue')
#      paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
#      currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
#      limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
#      isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and currentPaidDate > limitCurrentPaidDate and currentPaidDate < new Date()
#      payAmount = parseInt($(template.find("[name='paySaleAmount']")).inputmask('unmaskedvalue'))
#
#      if currentPaidDate >= latestSale.version.createdAt and isValidDate and payAmount != 0 and !isNaN(payAmount)
#        Session.set("allowCreateTransactionOfSale", true)
#      else
#        Session.set("allowCreateTransactionOfSale", false)

  scope.checkAllowCreateCustomSale = (template, customer)->
    latestCustomSale = Schema.customSales.findOne({buyer: customer._id}, {sort: {debtDate: -1}})

    $debtDate = $(template.find("[name='debtDate']")).inputmask('unmaskedvalue')
    tempDate = moment($debtDate, 'DD/MM/YYYY')._d
    debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
    limitDebtDate = new Date(tempDate.getFullYear() - 20, tempDate.getMonth(), tempDate.getDate())
    isValidDate = $debtDate.length is 8 and moment($debtDate, 'DD/MM/YYYY').isValid() and debtDate > limitDebtDate and debtDate < new Date()

    if isValidDate and (latestCustomSale is undefined || debtDate >= latestCustomSale.debtDate)
      Session.set("allowCreateCustomSale", true)
    else
      Session.set("allowCreateCustomSale", false)

  scope.checkAllowUpdateOverview = (template) ->
    Session.set "customerManagementShowEditCommand",
      template.ui.$customerName.val() isnt Session.get("customerManagementCurrentCustomer").name or
      template.ui.$customerPhone.val() isnt (Session.get("customerManagementCurrentCustomer").phone ? '') or
      template.ui.$customerAddress.val() isnt (Session.get("customerManagementCurrentCustomer").address ? '')