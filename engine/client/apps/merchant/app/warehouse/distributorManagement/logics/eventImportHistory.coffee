Apps.Merchant.distributorManagementInit.push (scope) ->
  scope.customImportModeDisable = (distributorId) ->
    distributor = Schema.distributors.findOne({_id: distributorId, parentMerchant:Session.get('myProfile').parentMerchant})
    if distributor and distributor.customImportModeEnabled is true
      Schema.distributors.update distributor._id, $set:{customImportModeEnabled: false}
      limitExpand = Session.get("distributorManagementDataMaxCurrentRecords")
      Meteor.subscribe('distributorManagementData', distributor._id, 0, limitExpand)


  scope.createCustomImport = (template)->
    if distributor = Session.get("distributorManagementCurrentDistributor")
      latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})
      $description = template.ui.$customImportDescription

      $debtDate = $(template.find("[name='customImportDebtDate']")).inputmask('unmaskedvalue')
      tempDate = moment($debtDate, 'DD/MM/YYYY')._d
      debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
      customImportDebtDate = new Date(latestCustomImport?.debtDate.getFullYear(), latestCustomImport?.debtDate.getMonth(), latestCustomImport?.debtDate.getDate())
      limitDebtDate = new Date(tempDate.getFullYear() - 20, tempDate.getMonth(), tempDate.getDate())
      isValidDate = $debtDate.length is 8 and moment($debtDate, 'DD/MM/YYYY').isValid() and debtDate > limitDebtDate and debtDate < (new Date)

      if isValidDate and (latestCustomImport is undefined || debtDate >= customImportDebtDate and debtDate < new Date())
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
        limitExpand    = Session.get("distributorManagementDataMaxCurrentRecords")
        currentRecords = Session.get("distributorManagementDataRecordCount")
        Meteor.subscribe('distributorManagementData', distributor._id, currentRecords, limitExpand)
      else
        console.log isValidDate , latestCustomImport is undefined, debtDate >= latestCustomImport.debtDate
#      Session.set("allowCreateCustomImport", false)

  scope.createCustomImportDetail = (template, customImport) ->
    console.log template
    $productName = $(template.find("[name='productName']"))
    $price       = $(template.find("[name='price']"))
    #    $totalPrice  = $(template.find("[name='totalPrice']"))
    $quality     = $(template.find("[name='quality']"))
    $skulls      = $(template.find("[name='skulls']"))

    price        = parseInt($price.inputmask('unmaskedvalue'))
    #    totalPrice   = parseInt($totalPrice.inputmask('unmaskedvalue'))


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

      latestCustomImport = Schema.customImports.findOne({seller: customImport.seller}, {sort: {debtDate: -1, 'version.createdAt': -1}})
      if customImport._id is latestCustomImport._id
        Meteor.call('updateCustomImportByCreateCustomImportDetail', customImportDetail)
        Meteor.call 'reCalculateMetroSummaryTotalPayableCash'

        limitExpand    = Session.get("distributorManagementDataMaxCurrentRecords")
        Meteor.subscribe('distributorManagementData', customImport.seller, 0, limitExpand)
      else console.log customImport._id, latestCustomImport._id
      $productName.val(''); $price.val(''); $quality.val(''); $skulls.val('')
      $productName.focus()

  scope.createTransactionOfCustomImport = (template)->
    $payDescription = template.ui.$payDescription

    $paidDate   = template.ui.$paidDate.inputmask('unmaskedvalue')
    paidDate    = moment($paidDate, 'DD/MM/YYYY')._d
    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid()

    $payAmount  = template.ui.$payAmount
    payAmount   = $($payAmount).inputmask('unmaskedvalue')

    if distributor = Session.get("distributorManagementCurrentDistributor")
      if latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})
        if latestTransaction = Schema.transactions.findOne({latestImport: latestCustomImport._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})
          customImportCreatedAt = new Date(
            latestTransaction.debtDate.getFullYear()
            latestTransaction.debtDate.getMonth()
            latestTransaction.debtDate.getDate()
          )
        else
          customImportCreatedAt = new Date(
            latestCustomImport.debtDate.getFullYear()
            latestCustomImport.debtDate.getMonth()
            latestCustomImport.debtDate.getDate()
          )

      if isValidDate and !isNaN(payAmount) and Number(payAmount) != 0 and (latestCustomImport is undefined || paidDate >= customImportCreatedAt)
        Meteor.call('createNewReceiptCashOfCustomImport', distributor._id, Number(payAmount), $payDescription.val(), paidDate)
        Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
        Session.set("allowCreateTransactionOfCustomImport", false)
        $payDescription.val(''); $payAmount.val('')
        limitExpand    = Session.get("distributorManagementDataMaxCurrentRecords")
        currentRecords = Session.get("distributorManagementDataRecordCount")
        Meteor.subscribe('distributorManagementData', distributor._id, currentRecords, limitExpand)


  scope.createTransactionOfImport = (template, distributor)->
#    if latestImport = Schema.imports.findOne({distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
    $payDescription = template.ui.$payImportDescription
    $payAmount = template.ui.$payImportAmount
    payAmount = parseInt($(template.find("[name='payImportAmount']")).inputmask('unmaskedvalue'))

    if !isNaN(payAmount) and payAmount != 0
      Meteor.call('createNewReceiptCashOfImport', distributor._id, Math.abs(payAmount), $payDescription.val())
      Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
      Session.set("allowCreateTransactionOfImport", false)
      $payDescription.val(''); $payAmount.val('')
      limitExpand    = Session.get("distributorManagementDataMaxCurrentRecords")
      currentRecords = Session.get("distributorManagementDataRecordCount")
      Meteor.subscribe('distributorManagementData', distributor._id, currentRecords, limitExpand)


#    if latestImport = Schema.imports.findOne({distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
#      importCreatedAt = new Date(latestImport.version.createdAt.getFullYear(), latestImport.version.createdAt.getMonth(), latestImport.version.createdAt.getDate())
#    $payDescription = template.ui.$payImportDescription
#    $paidDate = $(template.find("[name='paidImportDate']")).inputmask('unmaskedvalue')
#    paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
#    limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
#    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and paidDate > limitCurrentPaidDate and paidDate >= importCreatedAt
#
#    $payAmount = template.ui.$payImportAmount
#    payAmount = parseInt($(template.find("[name='payImportAmount']")).inputmask('unmaskedvalue'))
#
#    if latestImport and isValidDate and !isNaN(payAmount) and payAmount != 0
#      Meteor.call('createNewReceiptCashOfImport', distributor._id, payAmount, $payDescription.val())
#      Session.set("allowCreateTransactionOfImport", false)
#      $payDescription.val(''); $payAmount.val('')