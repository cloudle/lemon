Apps.Merchant.customerManagementInit.push (scope) ->
  scope.createCustomSale = (template) ->
    currentTime = new Date()

    $debtDate = template.ui.$debtDate
    $description = template.ui.$description
    tempDate = moment($debtDate.val(), 'DD/MM/YYYY')._d
    debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())
    customer = Session.get("customerManagementCurrentCustomer")

    if debtDate < (new Date) and !isNaN(customer.customSaleDebt)
      option =
        parentMerchant   : Session.get('myProfile').currentMerchant
        creator          : Session.get('myProfile').user
        buyer            : customer._id
        debtDate         : debtDate
        description      : $description.val()
        debtBalanceChange: 0
        beforeDebtBalance: customer.customSaleDebt
        latestDebtBalance: customer.customSaleDebt

      Meteor.call('createCustomSale', option)
      $debtDate.val(''); $description.val('')

  scope.createCustomSaleDetail = (customSale, template) ->
    $productName = $(template.find("[name='productName']"))
    $price       = $(template.find("[name='price']"))
#    $totalPrice  = $(template.find("[name='totalPrice']"))
    $quality     = $(template.find("[name='quality']"))
    $skulls      = $(template.find("[name='skulls']"))

    price        = parseInt($price.inputmask('unmaskedvalue'))
#    totalPrice   = parseInt($totalPrice.inputmask('unmaskedvalue'))

    console.log customSale, $productName.val().length > 0, $skulls.val().length > 0, price > 0, $quality.val() > 0

    if customSale and $productName.val().length > 0 and $skulls.val().length > 0 and price > 0 and $quality.val() > 0
      customSaleDetail =
        parentMerchant: Session.get('myProfile').parentMerchant
        creator       : Session.get('myProfile').user
        buyer         : Session.get("customerManagementCurrentCustomer")._id
        customSale    : customSale._id
        productName   : $productName.val()
        skulls        : $skulls.val()
        quality       : $quality.val()
        price         : price
        finalPrice    : $quality.val()*price

      latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
      if customSale._id is latestCustomSale._id
        Meteor.call('updateCustomSaleByCreateCustomSaleDetail', customSaleDetail)
      $productName.val(''); $price.val(''); $quality.val(''); $skulls.val('')
      $productName.focus()

  scope.deleteCustomSaleDetail = (customSaleDetailId) ->
    Meteor.call('updateCustomSaleByDeleteCustomSaleDetail', customSaleDetailId)

  scope.deleteTransactionCustomSale = (transactionCustomSaleDetailId) ->
    Meteor.call('deleteTransactionOfCustomSale', transactionCustomSaleDetailId)

  scope.customSaleModeDisable = (customerId) ->
    customer = Schema.customers.findOne({_id: customerId, parentMerchant:Session.get('myProfile').parentMerchant})
    if customer and customer.customSaleModeEnabled is true
      Schema.customers.update customer._id, $set:{customSaleModeEnabled: false}

  scope.confirmCustomSale = (customSaleId) ->
    customSale = Schema.customSales.findOne({_id:customSaleId, parentMerchant:Session.get('myProfile').parentMerchant})
    Transaction.newByCustomSale(customSale._id) if customSale.allowDelete is false and customSale.confirm is false

  scope.createTransactionOfCustomSale = (template) ->
    currentTime         = new Date()

    $payDescription = template.ui.$payDescription
    $payAmount      = $(template.find("[name='payAmount']"))
    $paidDate       = template.ui.$paidDate

    payAmount       = $payAmount.inputmask('unmaskedvalue')
    tempPaidDate    = moment($paidDate.val(), 'DD/MM/YYYY')._d
    paidDate        = new Date(tempPaidDate.getFullYear(), tempPaidDate.getMonth(), tempPaidDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())

    if customer = Session.get("customerManagementCurrentCustomer")
      latestCustomSale = Schema.customSales.findOne({buyer: customer._id}, {sort: {debtDate: -1}})
      console.log $payDescription.val() , (paidDate > latestCustomSale.debtDate if latestCustomSale) , payAmount != "" , !isNaN(payAmount)

      if latestCustomSale is undefined || (paidDate >= latestCustomSale.debtDate and payAmount != "" and !isNaN(payAmount))
        Meteor.call('createNewReceiptCashOfCustomSale', customer._id, parseInt(payAmount), $payDescription.val(), paidDate)
        $payDescription.val(''); $paidDate.val(''); $payAmount.val('')
