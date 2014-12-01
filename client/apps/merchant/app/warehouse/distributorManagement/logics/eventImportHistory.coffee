Apps.Merchant.distributorManagementInit.push (scope) ->
  scope.customImportModeDisable = ()->

  scope.createCustomImport = (template)->
    $debtDate = template.ui.$debtDate
    $description = template.ui.$description
    distributor = Session.get("distributorManagementCurrentDistributor")

    currentTime = new Date()
    tempDate    = moment($debtDate.val(), 'DD/MM/YYYY')._d
    debtDate    = new Date(
                            tempDate.getFullYear()
                            tempDate.getMonth()
                            tempDate.getDate()
                            currentTime.getHours()
                            currentTime.getMinutes()
                            currentTime.getSeconds()
                          )


    if distributor and debtDate < (new Date) and !isNaN(distributor.customImportDebt)
      option =
        parentMerchant   : Session.get('myProfile').currentMerchant
        creator          : Session.get('myProfile').user
        seller           : distributor._id
        debtDate         : debtDate
        description      : $description.val()
        debtBalanceChange: 0
        beforeDebtBalance: distributor.customImportDebt
        latestDebtBalance: distributor.customImportDebt

      Meteor.call('createNewCustomImport', option)
      $debtDate.val(''); $description.val('')
    else
      console.log distributor , debtDate < (new Date) , !isNaN(distributor.customImportDebt)

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
      console.log $payDescription.val() , (paidDate > latestCustomImport.debtDate if latestCustomImport) , payAmount != "" , !isNaN(payAmount)

      if latestCustomImport is undefined || (paidDate >= latestCustomImport.debtDate and payAmount != "" and !isNaN(payAmount))
        Meteor.call('createNewReceiptCashOfCustomImport', distributor._id, parseInt(payAmount), $payDescription.val(), paidDate)
        $payDescription.val(''); $paidDate.val(''); $payAmount.val('')

