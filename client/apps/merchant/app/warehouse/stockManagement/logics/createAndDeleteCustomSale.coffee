Apps.Merchant.stockManagementInit.push (scope) ->
#  scope.createCustomSale = (template) ->
#    currentTime = new Date()
#
#    $debtDate = template.ui.$debtDate
#    $description = template.ui.$description
#    tempDate = moment($debtDate.val(), 'DD/MM/YYYY')._d
#    debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())
#    stock = Session.get("stockManagementCurrentStock")
#
#    if debtDate < (new Date) and !isNaN(stock.customSaleDebt)
#      option =
#        parentMerchant   : Session.get('myProfile').currentMerchant
#        creator          : Session.get('myProfile').user
#        buyer            : stock._id
#        debtDate         : debtDate
#        description      : $description.val()
#        debtBalanceChange: 0
#        beforeDebtBalance: stock.customSaleDebt
#        latestDebtBalance: stock.customSaleDebt
#
#      Meteor.call('createCustomSale', option)
#      $debtDate.val(''); $description.val('')
#
#  scope.createCustomSaleDetail = (customSale, template) ->
#    $productName = $(template.find("[name='productName']"))
#    $price       = $(template.find("[name='price']"))
##    $totalPrice  = $(template.find("[name='totalPrice']"))
#    $quality     = $(template.find("[name='quality']"))
#    $skulls      = $(template.find("[name='skulls']"))
#
#    price        = parseInt($price.inputmask('unmaskedvalue'))
##    totalPrice   = parseInt($totalPrice.inputmask('unmaskedvalue'))
#
#    console.log customSale, $productName.val().length > 0, $skulls.val().length > 0, price > 0, $quality.val() > 0
#
#    if customSale and $productName.val().length > 0 and $skulls.val().length > 0 and price > 0 and $quality.val() > 0
#      customSaleDetail =
#        parentMerchant: Session.get('myProfile').parentMerchant
#        creator       : Session.get('myProfile').user
#        buyer         : Session.get("stockManagementCurrentStock")._id
#        customSale    : customSale._id
#        productName   : $productName.val()
#        skulls        : $skulls.val()
#        quality       : $quality.val()
#        price         : price
#        finalPrice    : $quality.val()*price
#
#      latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
#      if customSale._id is latestCustomSale._id
#        Meteor.call('updateCustomSaleByCreateCustomSaleDetail', customSaleDetail)
#      $productName.val(''); $price.val(''); $quality.val(''); $skulls.val('')
#      $productName.focus()
#
#  scope.deleteCustomSaleDetail = (customSaleDetailId) ->
#    Meteor.call('updateCustomSaleByDeleteCustomSaleDetail', customSaleDetailId)
#
#  scope.deleteTransactionCustomSale = (transactionCustomSaleDetailId) ->
#    Meteor.call('deleteTransactionOfCustomSale', transactionCustomSaleDetailId)
#
#  scope.customSaleModeDisable = (stockId) ->
#    stock = Schema.stocks.findOne({_id: stockId, parentMerchant:Session.get('myProfile').parentMerchant})
#    if stock and stock.customSaleModeEnabled is true
#      Schema.stocks.update stock._id, $set:{customSaleModeEnabled: false}
#
#  scope.createTransactionOfCustomSale = (template) ->
#    currentTime     = new Date()
#
#    $payDescription = template.ui.$payDescription
#    $payAmount      = $(template.find("[name='payAmount']"))
#    $paidDate       = template.ui.$paidDate
#
#    payAmount       = parseInt($payAmount.inputmask('unmaskedvalue'))
#    tempPaidDate    = moment($paidDate.val(), 'DD/MM/YYYY')._d
#    paidDate        = new Date(tempPaidDate.getFullYear(), tempPaidDate.getMonth(), tempPaidDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())
#
#    if stock = Session.get("stockManagementCurrentStock")
#      latestCustomSale = Schema.customSales.findOne({buyer: stock._id}, {sort: {debtDate: -1}})
#
#      if latestCustomSale is undefined || (paidDate >= latestCustomSale.debtDate and !isNaN(payAmount))
#        Meteor.call('createNewReceiptCashOfCustomSale', stock._id, payAmount, $payDescription.val(), paidDate)
#        Session.set("allowCreateTransactionOfCustomSale", false)
#        $payDescription.val(''); $payAmount.val('');# $paidDate.val('')
#
#  scope.createTransactionOfSale = (template) ->
#    currentTime     = new Date()
#
#    $payDescription = template.ui.$paySaleDescription
#    $payAmount      = $(template.find("[name='paySaleAmount']"))
#    $paidDate       = template.ui.$paidSaleDate
#
#    payAmount       = $payAmount.inputmask('unmaskedvalue')
#    tempPaidDate    = moment($paidDate.val(), 'DD/MM/YYYY')._d
#    paidDate        = new Date(tempPaidDate.getFullYear(), tempPaidDate.getMonth(), tempPaidDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())
#
#    if stock = Session.get("stockManagementCurrentStock")
#      latestSale = Schema.sales.findOne({buyer: stock._id}, {sort: {'version.createdAt': -1}})
#      console.log $payDescription.val() , (paidDate > latestSale.version.createdAt if latestSale) , payAmount != "" , !isNaN(payAmount)
#
#      if paidDate >= latestSale?.version.createdAt and payAmount != "" and !isNaN(payAmount)
#        Meteor.call('createNewReceiptCashOfSales', stock._id, parseInt(payAmount), $payDescription.val(), paidDate)
#        $payDescription.val(''); $paidDate.val(''); $payAmount.val('')