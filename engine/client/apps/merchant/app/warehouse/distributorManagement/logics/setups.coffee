Apps.Merchant.distributorManagementInit.push (scope) ->
  scope.checkAllowCreateCustomImport = (template, distributor)->
    latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})

#    isValidDescription = template.find("[name='customImportDescription']").value.length > 0
    $debtDate = $(template.find("[name='customImportDebtDate']")).inputmask('unmaskedvalue')
    tempDate = moment($debtDate, 'DD/MM/YYYY')._d
    debtDate = new Date(tempDate.getFullYear(), tempDate.getMonth(), tempDate.getDate())
    customImportDebtDate = new Date(latestCustomImport?.debtDate.getFullYear(), latestCustomImport?.debtDate.getMonth(), latestCustomImport?.debtDate.getDate())
    limitDebtDate = new Date((new Date()).getFullYear() - 20, (new Date()).getMonth(), (new Date()).getDate())
    isValidDate = $debtDate.length is 8 and moment($debtDate, 'DD/MM/YYYY').isValid() and debtDate > limitDebtDate

    if isValidDate and (latestCustomImport is undefined || debtDate >= customImportDebtDate and debtDate < new Date())
      console.log 'true'
      Session.set("allowCreateCustomImport", true)
    else
      console.log 'false'
      Session.set("allowCreateCustomImport", false)

  scope.checkAllowCreateTransactionOfCustomImport = (template, distributor)->
    if latestCustomImport = Schema.customImports.findOne({seller: distributor._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})
      latestTransaction = Schema.transactions.findOne({latestImport: latestCustomImport._id}, {sort: {debtDate: -1, 'version.createdAt': -1}})

    $paidDate = $(template.find("[name='paidDate']")).inputmask('unmaskedvalue')
    paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
    currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate())
    limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
    isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and currentPaidDate > limitCurrentPaidDate and currentPaidDate < new Date()
    payAmount = parseInt($(template.find("[name='payAmount']")).inputmask('unmaskedvalue'))

    if isValidDate and payAmount != 0 and !isNaN(payAmount)
      if latestCustomImport
        if latestTransaction then debtDate = latestTransaction.debtDate else debtDate = latestCustomImport.debtDate
        if currentPaidDate >= debtDate
          Session.set("allowCreateTransactionOfCustomImport", true)
        else
          Session.set("allowCreateTransactionOfCustomImport", false)
      else
        Session.set("allowCreateTransactionOfCustomImport", true)
    else
      Session.set("allowCreateTransactionOfCustomImport", false)

#    if isValidDate and payAmount != 0 and (latestCustomImport is undefined  || currentPaidDate >= latestCustomImport?.debtDate and !isNaN(payAmount))
#      Session.set("allowCreateTransactionOfCustomImport", true)
#    else
#      Session.set("allowCreateTransactionOfCustomImport", false)

  scope.checkAllowCreateTransactionOfImport = (template, distributor)->
    payAmount = parseInt($(template.find("[name='payImportAmount']")).inputmask('unmaskedvalue'))
    if payAmount != 0 and !isNaN(payAmount)
      Session.set("allowCreateTransactionOfImport", true)
    else
      Session.set("allowCreateTransactionOfImport", false)

#    if latestImport = Schema.imports.findOne({distributor: distributor._id, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
#      payAmount = parseInt($(template.find("[name='payImportAmount']")).inputmask('unmaskedvalue'))
#      if payAmount != 0 and !isNaN(payAmount)
#        Session.set("allowCreateTransactionOfImport", true)
#      else
#        Session.set("allowCreateTransactionOfImport", false)
#      latestTransaction = Schema.transactions.findOne({latestImport: latestImport._id}, {sort: {debtDate: -1}})
#
#      $paidDate = $(template.find("[name='paidImportDate']")).inputmask('unmaskedvalue')
#      paidDate  = moment($paidDate, 'DD/MM/YYYY')._d
#      currentPaidDate = new Date(paidDate.getFullYear(), paidDate.getMonth(), paidDate.getDate(), (new Date).getHours(), (new Date).getMinutes(), (new Date).getSeconds())
#      limitCurrentPaidDate = new Date(paidDate.getFullYear() - 20, paidDate.getMonth(), paidDate.getDate())
#      isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid() and currentPaidDate > limitCurrentPaidDate and currentPaidDate < new Date()
#      payAmount = parseInt($(template.find("[name='payImportAmount']")).inputmask('unmaskedvalue'))
#
#      if isValidDate and payAmount != 0 and !isNaN(payAmount)
#        if latestImport
#          if latestTransaction then debtDate = latestTransaction.debtDate else debtDate = latestImport.version.createdAt
#          if currentPaidDate >= debtDate
#            Session.set("allowCreateTransactionOfImport", true)
#          else
#            Session.set("allowCreateTransactionOfImport", false)
#        else
#          Session.set("allowCreateTransactionOfImport", true)
#      else
#        Session.set("allowCreateTransactionOfImport", false)

  scope.checkAllowUpdateDistributorOverview = (template) ->
    Session.set "distributorManagementShowEditCommand",
      template.ui.$distributorName.val() isnt Session.get("distributorManagementCurrentDistributor").name or
      template.ui.$distributorPhone.val() isnt (Session.get("distributorManagementCurrentDistributor").phone ? '') or
      template.ui.$distributorAddress.val() isnt (Session.get("distributorManagementCurrentDistributor").location?.address ? '')

#  scope.checkAllowUpdateDistributorOverview = (template) ->
#    if distributor = Session.get("distributorManagementCurrentDistributor")
#      name    = template.ui.$distributorName.val()
#      phone   = template.ui.$distributorPhone.val()
#      address = template.ui.$distributorAddress.val()
#
#      isValidName    = name isnt distributor.name
#      isValidPhone   = phone isnt (distributor.phone ? '')
#      isValidAddress = address isnt (distributor.location?.address ? '')
#
#      distributorFound = Schema.distributors.findOne {name: name, parentMerchant: Session.get('myProfile').parentMerchant}
#      if name.length is 0
#        template.ui.$distributorName.notify("Tên nhà phân phối không thể để trống.", {position: "right"})
#      else if distributorFound and distributorFound._id isnt distributor._id
#        template.ui.$distributorName.notify("Tên nhà phân phối đã tồn tại.", {position: "right"})
#        Session.set "distributorManagementShowEditCommand"
#      else
#        Session.set "distributorManagementShowEditCommand", isValidName or isValidPhone or isValidAddress

  scope.createDistributorBySearchFilter = (template) ->
    fullText    = Session.get("distributorManagementSearchFilter")

    if fullText.indexOf("(") > 0
      namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
      descPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    else
      namePart    = fullText
      descPart    = ""

    #    console.log(namePart, descPart)
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
      console.log result
      if result.error then $name.notify(result.error, {position: "bottom"})
      else
        Meteor.call 'updateMetroSummaryBy', 'createDistributor', result
        UserSession.set('currentDistributorManagementSelection', result)
      template.ui.$searchFilter.val(''); Session.set("distributorManagementSearchFilter", "")

  scope.editDistributor = (template) ->
    distributor = Session.get("distributorManagementCurrentDistributor")
    if distributor and Session.get("distributorManagementShowEditCommand")
      name  = template.ui.$distributorName.val()
      phone = template.ui.$distributorPhone.val()
      address = template.ui.$distributorAddress.val()

      editOptions = {}
      editOptions.phone = phone if phone.length > 0
      editOptions.location = {address: [address]} if address.length > 0
      if name.length > 0
        editOptions.name = name
        distributorFound = Schema.distributors.findOne {name: name, parentMerchant: distributor.parentMerchant}

      if name.length is 0
        template.ui.$distributorName.notify("Tên nhà phân phối không thể để trống.", {position: "right"})
      else if distributorFound and distributorFound._id isnt distributor._id
        template.ui.$distributorName.notify("Tên nhà phân phối đã tồn tại.", {position: "right"})
        template.ui.$distributorName.val name
        Session.set("distributorManagementShowEditCommand", false)
      else
        Schema.distributors.update distributor._id, {$set: editOptions}, (error, result) -> if error then console.log error
        template.ui.$distributorName.val editOptions.name
        Session.set("distributorManagementShowEditCommand", false)

  scope.deleteDistributor = (distributor) ->
    if distributor.allowDelete
      if Schema.distributors.remove distributor._id
        UserSession.set('currentDistributorManagementSelection', Schema.distributors.findOne()?._id ? '')
        Meteor.call 'updateMetroSummaryBy', 'deleteDistributor', distributor
