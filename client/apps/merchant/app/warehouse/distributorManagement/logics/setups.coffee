resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")
Apps.Merchant.distributorManagementInit.push (scope) ->
  Session.set("distributorManagementSearchFilter", "")
  Session.set("distributorManagementCurrentDistributor", Schema.distributors.findOne())

  scope.createDistributor = (context)->
    $name    = context.ui.$distributorName
    $phone   = context.ui.$distributorPhone
    $address = context.ui.$distributorAddress

    result = Distributor.createNew($name.val(), $phone.val(), $address.val())
    if result.error then $name.notify(result.error, {position: "bottom"})
    else Session.set('allowCreateDistributor', false)

  scope.createDistributorBySearchFilter = (template) ->
    fullText    = Session.get("distributorManagementSearchFilter")

    if fullText.indexOf("(") > 0
      namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
      descPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    else
      namePart    = fullText
      descPart    = ""

    console.log(namePart, descPart)
#    distributor =
#      currentMerchant : Session.get('myProfile').currentMerchant
#      parentMerchant  : Session.get('myProfile').parentMerchant
#      creator         : Session.get('myProfile').user
#      name            : namePart
#
#    distributor.description = descPart if descPart.length > 0

    existedQuery = {name: namePart, parentMerchant: Session.get('myProfile').parentMerchant}
#    existedQuery.description = descPart if descPart.length > 0
    if Schema.distributors.findOne existedQuery
      template.ui.$searchFilter.notify("Nhà phân phối đã tồn tại.", {position: "bottom"})
    else
      result = Distributor.createNew(namePart)
      if result.error then $name.notify(result.error, {position: "bottom"})
      else
        MetroSummary.updateMetroSummaryBy(['distributor'])
        UserSession.set('currentDistributorManagementSelection', result.result)
      template.ui.$searchFilter.val(''); Session.set("distributorManagementSearchFilter", "")

  scope.checkAllowCreateDistributor = (context) ->
    $name = context.ui.$distributorName
    if $name.val().length > 0
      if _.findWhere(Schema.distributors.find({parentMerchant: Session.get("myProfile").parentMerchant}).fetch(), {name: $name.val()})
        Session.set('allowCreateDistributor', false)
      else Session.set('allowCreateDistributor', true)
    else Session.set('allowCreateDistributor', false)



  scope.checkAllowCreateCustomImport = (template, distributor)->
    latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1}})

    $debtDate = $(template.find("[name='customImportDebtDate']")).inputmask('unmaskedvalue')
    tempDate = moment($debtDate, 'DD/MM/YYYY')._d
    debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
    limitDebtDate = new Date(tempDate.getFullYear() - 20, tempDate.getMonth(), tempDate.getDate())
    isValidDate = $debtDate.length is 8 and moment($debtDate, 'DD/MM/YYYY').isValid() and debtDate > limitDebtDate

    if isValidDate and (latestCustomImport is undefined || debtDate >= latestCustomImport.debtDate)
      Session.set("allowCreateCustomImport", true)
    else
      Session.set("allowCreateCustomImport", false)

  scope.checkAllowCreateTransactionOfCustomImport = (template, distributor)->
    latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1}})

    $paidDate = $(template.find("[name='paidDate']")).inputmask('unmaskedvalue')
    paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
    currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
    limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and currentPaidDate > limitCurrentPaidDate
    payAmount = parseInt($(template.find("[name='payAmount']")).inputmask('unmaskedvalue'))

    if isValidDate and payAmount != 0 and (latestCustomImport is undefined  || currentPaidDate >= latestCustomImport?.debtDate and !isNaN(payAmount))
      Session.set("allowCreateTransactionOfCustomImport", true)
    else
      Session.set("allowCreateTransactionOfCustomImport", false)

  scope.checkAllowCreateTransactionOfImport = (template, distributor)->
    latestImport = Schema.imports.findOne({distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})

    $paidDate = $(template.find("[name='paidSaleDate']")).inputmask('unmaskedvalue')
    paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
    currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
    limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and currentPaidDate > limitCurrentPaidDate and currentPaidDate >= latestImport.version.createdAt
    payAmount = parseInt($(template.find("[name='paySaleAmount']")).inputmask('unmaskedvalue'))

    if latestImport and isValidDate and !isNaN(payAmount) and payAmount != 0
      Session.set("allowCreateTransactionOfImport", true)
    else
      Session.set("allowCreateTransactionOfImport", false)