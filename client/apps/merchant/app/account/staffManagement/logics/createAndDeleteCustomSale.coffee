Apps.Merchant.staffManagementInit.push (scope) ->
  scope.createCustomSale = (template) ->
    currentTime = new Date()

    $debtDate = template.ui.$debtDate
    $description = template.ui.$description
    tempDate = moment($debtDate.val(), 'DD/MM/YYYY')._d
    debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())
    staff = Session.get("staffManagementCurrentStaff")

    if debtDate < (new Date) and !isNaN(staff.customSaleDebt)
      option =
        parentMerchant   : Session.get('myProfile').currentMerchant
        creator          : Session.get('myProfile').user
        buyer            : staff._id
        debtDate         : debtDate
        description      : $description.val()
        debtBalanceChange: 0
        beforeDebtBalance: staff.customSaleDebt
        latestDebtBalance: staff.customSaleDebt

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
        buyer         : Session.get("staffManagementCurrentStaff")._id
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

  scope.customSaleModeDisable = (staffId) ->
    staff = Schema.staffs.findOne({_id: staffId, parentMerchant:Session.get('myProfile').parentMerchant})
    if staff and staff.customSaleModeEnabled is true
      Schema.staffs.update staff._id, $set:{customSaleModeEnabled: false}

  scope.createTransactionOfCustomSale = (template) ->
    currentTime     = new Date()

    $payDescription = template.ui.$payDescription
    $payAmount      = $(template.find("[name='payAmount']"))
    $paidDate       = template.ui.$paidDate

    payAmount       = parseInt($payAmount.inputmask('unmaskedvalue'))
    tempPaidDate    = moment($paidDate.val(), 'DD/MM/YYYY')._d
    paidDate        = new Date(tempPaidDate.getFullYear(), tempPaidDate.getMonth(), tempPaidDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())

    if staff = Session.get("staffManagementCurrentStaff")
      latestCustomSale = Schema.customSales.findOne({buyer: staff._id}, {sort: {debtDate: -1}})

      if latestCustomSale is undefined || (paidDate >= latestCustomSale.debtDate and !isNaN(payAmount))
        Meteor.call('createNewReceiptCashOfCustomSale', staff._id, payAmount, $payDescription.val(), paidDate)
        Session.set("allowCreateTransactionOfCustomSale", false)
        $payDescription.val(''); $payAmount.val('');# $paidDate.val('')

  scope.createTransactionOfSale = (template) ->
    staff = Session.get("staffManagementCurrentStaff")
    if staff and Session.get("allowCreateTransactionOfSale")
      $payDescription = template.ui.$paySaleDescription
      $payAmount      = $(template.find("[name='paySaleAmount']"))
      payAmount       = parseInt($payAmount.inputmask('unmaskedvalue'))
      description     = $payDescription.val()

#    currentTime     = new Date()
#    $paidDate       = template.ui.$paidSaleDate
#    tempPaidDate    = moment($paidDate.val(), 'DD/MM/YYYY')._d
#    paidDate        = new Date(tempPaidDate.getFullYear(), tempPaidDate.getMonth(), tempPaidDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())

#    console.log latestSale = Schema.sales.findOne({buyer: staff._id}, {sort: {'version.createdAt': -1}})
#    console.log $payDescription.val() , (paidDate > latestSale.version.createdAt if latestSale) , payAmount != "" , !isNaN(payAmount)

      console.log staff
      if Schema.sales.findOne({buyer: staff._id}) and payAmount != 0 and !isNaN(payAmount) # and paidDate >= latestSale?.version.createdAt
        Meteor.call('createNewReceiptCashOfSales', staff._id, payAmount, description)
        Session.set("allowCreateTransactionOfSale", false)
        $payDescription.val(''); $payAmount.val('')
      else
        console.log $payDescription.val() , payAmount != 0 , !isNaN(payAmount), payAmount, Schema.sales.findOne()