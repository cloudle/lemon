Apps.Merchant.productManagementInit.push (scope) ->
#  scope.checkAllowCreateTransactionOfCustomSale = (template, product)->
#    latestCustomSale = Schema.customSales.findOne({buyer: product._id}, {sort: {debtDate: -1}})
#
#    $paidDate = $(template.find("[name='paidDate']")).inputmask('unmaskedvalue')
#    paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
#    currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
#    limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
#    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and currentPaidDate > limitCurrentPaidDate
#    payAmount = parseInt($(template.find("[name='payAmount']")).inputmask('unmaskedvalue'))
#
#    if isValidDate and payAmount != 0 and (latestCustomSale is undefined  || currentPaidDate >= latestCustomSale?.debtDate and !isNaN(payAmount))
#      Session.set("allowCreateTransactionOfCustomSale", true)
#    else
#      Session.set("allowCreateTransactionOfCustomSale", false)
#
#  scope.checkAllowCreateCustomSale = (template, product)->
#    latestCustomSale = Schema.customSales.findOne({buyer: product._id}, {sort: {debtDate: -1}})
#
#    $debtDate = $(template.find("[name='debtDate']")).inputmask('unmaskedvalue')
#    tempDate = moment($debtDate, 'DD/MM/YYYY')._d
#    debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
#    limitDebtDate = new Date(tempDate.getFullYear() - 20, tempDate.getMonth(), tempDate.getDate())
#    isValidDate = $debtDate.length is 8 and moment($debtDate, 'DD/MM/YYYY').isValid() and debtDate > limitDebtDate
#
#    if isValidDate and (latestCustomSale is undefined || debtDate >= latestCustomSale.debtDate)
#      Session.set("allowCreateCustomSale", true)
#    else
#      Session.set("allowCreateCustomSale", false)