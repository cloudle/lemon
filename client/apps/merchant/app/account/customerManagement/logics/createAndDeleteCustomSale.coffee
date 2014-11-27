Apps.Merchant.customerManagementInit.push (scope) ->
  scope.createCustomSale = (event, template) ->
    $debtDate = template.ui.$debtDate
    $description = template.ui.$description
    debtDate = moment($debtDate.val(), 'DD/MM/YYYY')._d
    customer = Session.get("customerManagementCurrentCustomer")
    if debtDate < (new Date) and customer.debtBalance
      option =
        parentMerchant   : Session.get('myProfile').currentMerchant
        creator          : Session.get('myProfile').user
        buyer            : Session.get("customerManagementCurrentCustomer")._id
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
    $quality     = $(template.find("[name='quality']"))
    $skulls      = $(template.find("[name='skulls']"))

    console.log customSale, $productName.val().length > 0, $skulls.val().length > 0, $price.val() > 0, $quality.val() > 0

    if customSale and $productName.val().length > 0 and $skulls.val().length > 0 and $price.val() > 0 and $quality.val() > 0
      customSaleDetail =
        parentMerchant: Session.get('myProfile').parentMerchant
        creator       : Session.get('myProfile').user
        buyer         : Session.get("customerManagementCurrentCustomer")._id
        customSale    : customSale._id
        productName   : $productName.val()
        skulls        : $skulls.val()
        price         : $price.val()
        quality       : $quality.val()
        finalPrice    : $quality.val()*$price.val()

      latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
      if customSale._id is latestCustomSale._id
        Meteor.call('updateCustomSaleByCreateCustomSaleDetail', customSaleDetail)
      $productName.val(''); $price.val(''); $quality.val(''); $skulls.val('')

  scope.deleteCustomSaleDetail = (customSaleDetailId) ->
    Meteor.call('updateCustomSaleByDeleteCustomSaleDetail', customSaleDetailId)

  scope.confirmCustomSale = (customSaleId) ->
    customSale = Schema.customSales.findOne({_id:customSaleId, parentMerchant:Session.get('myProfile').parentMerchant})
    Transaction.newByCustomSale(customSale._id) if customSale.allowDelete is false and customSale.confirm is false

  scope.createTransaction = (event, template) ->
    $payDescription = template.ui.$payDescription
    $payAmount = template.ui.$payAmount
    $paidDate = template.ui.$paidDate
    paidDate = moment($paidDate.val(), 'DD/MM/YYYY')._d
    customer = Session.get("customerManagementCurrentCustomer")
    console.log $payAmount.val()
#    if customer and paidDate < (new Date) and $payAmount.val()
#      Meteor.call('createNewReceiptCashOfCustomSale', customer._id, $payAmount.val(), $payDescription.val())


