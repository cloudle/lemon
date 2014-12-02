Apps.Merchant.distributorManagementInit.push (scope) ->
  scope.customImportModeDisable = ()->

  scope.createCustomImport = (template)->
    if distributor = Session.get("distributorManagementCurrentDistributor")
      latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1}})
      $description = template.ui.$description

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
          description      : $description.val()
          beforeDebtBalance: distributor.customImportDebt ? 0
          latestDebtBalance: distributor.customImportDebt ? 0

        Meteor.call('createNewCustomImport', option)
        $debtDate.val(''); $description.val('')
      else
        console.log isValidDate , latestCustomImport is undefined, debtDate >= latestCustomImport.debtDate


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

