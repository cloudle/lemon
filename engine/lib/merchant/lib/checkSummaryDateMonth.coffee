Apps.Merchant.checkSummaryDate = (profile)->
  if profile
    toDate = new Date((new Date()).getFullYear(), (new Date()).getMonth(), (new Date()).getDate())
    allMerchant = Schema.merchants.find({$or:[{_id: profile.parentMerchant }, {parent: profile.parentMerchant}]})
    for branch in allMerchant.fetch()
      option =
        saleCountDay      : 0
        deliveryCountDay  : 0
        importCountDay    : 0
        inventoryCountDay : 0
        transferCountDay  : 0
        returnCustomerCountDay    : 0
        returnDistributorCountDay : 0

        discountDay       : 0
        depositDay        : 0
        debitDay          : 0
        revenueDay        : 0
        cogsDay           : 0
        profitabilityDay  : 0

        salesMoneyDay : 0
        importMoneyDay: 0
        returnMoneyOfDistributorDay: 0
        returnMoneyOfCustomerDay   : 0

      Schema.sales.find({ merchant: branch._id, 'version.createdAt': {$gte: toDate} }).forEach(
        (sale) -> option.salesMoneyDay += sale.debtBalanceChange
      )
      Schema.imports.find({merchant: branch._id, 'version.createdAt': {$gte: toDate}, finish: true, submitted: true}).forEach(
        (currentImport) -> option.importMoneyDay += currentImport.debtBalanceChange
      )
      Schema.returns.find({merchant: branch._id, 'version.createdAt': {$gte: toDate}, status: 2 }).forEach(
        (currentReturn) ->
          if currentReturn.returnMethods is 0
            option.returnMoneyOfCustomerDay += currentReturn.debtBalanceChange
          else
            option.returnMoneyOfDistributorDay += currentReturn.debtBalanceChange
      )

      Schema.metroSummaries.update({merchant: branch._id},{$set: option})
      Schema.branchProfiles.update({merchant: branch._id}, {$set:{latestCheckSummaryDate: new Date()}})


Apps.Merchant.checkSummaryMonth = (profile)->
  if profile
    toMonth = new Date((new Date()).getFullYear(), (new Date()).getMonth(), 1)
    allMerchant = Schema.merchants.find({$or:[{_id: profile.parentMerchant }, {parent: profile.parentMerchant}]})
    for branch in allMerchant.fetch()
      option =
        saleCountMonth      : 0
        deliveryCountMonth  : 0
        importCountMonth    : 0
        inventoryCountMonth : 0
        transferCountMonth  : 0
        returnCustomerCountMonth    : 0
        returnDistributorCountMonth : 0

      Schema.metroSummaries.update({merchant: branch._id},{$set: option})
      Schema.branchProfiles.update({merchant: branch._id}, {$set:{latestCheckSummaryMonth: new Date()}})

