Apps.Merchant.distributorManagementInit.push (scope) ->
  scope.customImportModeDisable = ()->

  scope.createCustomImport = (template)->
    if distributor = Session.get("distributorManagementCurrentDistributor")
      latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1}})
      $description = template.ui.$customImportDescription

      $debtDate = $(template.find("[name='customImportDebtDate']")).inputmask('unmaskedvalue')
      tempDate = moment($debtDate, 'DD/MM/YYYY')._d
      debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
      limitDebtDate = new Date(tempDate.getFullYear() - 20, tempDate.getMonth(), tempDate.getDate())
      isValidDate = $debtDate.length is 8 and moment($debtDate, 'DD/MM/YYYY').isValid() and debtDate > limitDebtDate and debtDate < (new Date)

      if isValidDate and (latestCustomImport is undefined || debtDate >= latestCustomImport.debtDate)
        option =
          parentMerchant   : Session.get('myProfile').currentMerchant
          creator          : Session.get('myProfile').user
          seller           : distributor._id
          debtDate         : debtDate
          beforeDebtBalance: distributor.customImportDebt ? 0
          latestDebtBalance: distributor.customImportDebt ? 0
        option.description = $description.val() if $description.val().length > 0

        Meteor.call('createNewCustomImport', option)
        $(template.find("[name='customImportDebtDate']")).val(''); $description.val('')
      else
        console.log isValidDate , latestCustomImport is undefined, debtDate >= latestCustomImport.debtDate

  scope.createCustomImportDetail = (template, customImport) ->
    console.log template
    $productName = $(template.find("[name='productName']"))
    $price       = $(template.find("[name='price']"))
    #    $totalPrice  = $(template.find("[name='totalPrice']"))
    $quality     = $(template.find("[name='quality']"))
    $skulls      = $(template.find("[name='skulls']"))

    price        = parseInt($price.inputmask('unmaskedvalue'))
    #    totalPrice   = parseInt($totalPrice.inputmask('unmaskedvalue'))

    console.log customImport, $productName.val().length > 0, $skulls.val().length > 0, price > 0, $quality.val() > 0

    if customImport and $productName.val().length > 0 and $skulls.val().length > 0 and price > 0 and $quality.val() > 0
      customImportDetail =
        parentMerchant: Session.get('myProfile').parentMerchant
        creator       : Session.get('myProfile').user
        seller        : customImport.seller
        customImport  : customImport._id
        productName   : $productName.val()
        skulls        : $skulls.val()
        quality       : $quality.val()
        price         : price
        finalPrice    : $quality.val()*price

      latestCustomImport = Schema.customImports.findOne({buyer: customImport.buyer}, {sort: {debtDate: -1}})
      if customImport._id is latestCustomImport._id
        Meteor.call('updateCustomImportByCreateCustomImportDetail', customImportDetail)
      $productName.val(''); $price.val(''); $quality.val(''); $skulls.val('')
      $productName.focus()

  scope.createTransactionOfCustomImport = (template)->
    currentTime         = new Date()

    $payDescription = template.ui.$payDescription
    $payAmount      = $(template.find("[name='payAmount']"))
    $paidDate       = template.ui.$paidDate

    payAmount       = $payAmount.inputmask('unmaskedvalue')
    tempPaidDate    = moment($paidDate.val(), 'DD/MM/YYYY')._d
    paidDate        = new Date(tempPaidDate.getFullYear(), tempPaidDate.getMonth(), tempPaidDate.getDate(), currentTime.getHours(), currentTime.getMinutes(), currentTime.getSeconds())

    if distributor = Session.get("distributorManagementCurrentDistributor")
      latestCustomImport = Schema.customImports.findOne({buyer: distributor._id}, {sort: {debtDate: -1}})
      console.log paidDate
      console.log latestCustomImport.debtDate if latestCustomImport

      if latestCustomImport is undefined || (paidDate >= latestCustomImport.debtDate and payAmount != "" and !isNaN(payAmount))
        Meteor.call('createNewReceiptCashOfCustomImport', distributor._id, parseInt(payAmount), $payDescription.val(), paidDate)
        $payDescription.val(''); $paidDate.val(''); $payAmount.val('')

