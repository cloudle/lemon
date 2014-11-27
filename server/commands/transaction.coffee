calculateCustomer = ()->

Meteor.methods
  deleteTransaction: (id)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if !profile then throw 'Không tìm thấy profile'

#      permission = Role.hasPermission(profile._id, Apps.Merchant.Permissions.transactionManagement.key)
#      if permission is false then throw 'Bạn không có quyền thực hiên.'

      transaction = Schema.transactions.findOne({_id: id, merchant: profile.currentMerchant})
      if !transaction then throw 'Không tìm thấy transaction'

      transactionDetails = Schema.transactionDetails.find({transaction: transaction._id})
      if transactionDetails.count() > 1 then throw 'Không thể xóa transaction khi thêm mới transactionDetails '

      if transaction.allowDelete is true and transaction.group is 'customer'
        Schema.transactions.remove transaction._id
        Schema.transactionDetails.remove {transaction: transaction._id}
        MetroSummary.updateMetroSummaryByDestroyTransaction(transaction.merchant, transaction.debitCash)
        Schema.customers.update transaction.owner, $inc:{totalPurchases: -transaction.totalCash, totalDebit: -transaction.debitCash}
        Schema.notifications.remove {product: transaction._id}

        return true
      else throw 'Xóa transaction không thành công'

    catch error
      throw new Meteor.Error('deleteTransaction', error)

  addTransactionDetail: (transactionId, depositCash, paymentDate)->
    try
      profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if !profile then throw 'Không tìm thấy profile'

#      permission = Role.hasPermission(profile._id, Apps.Merchant.Permissions.transactionManagement.key)
#      if permission is false then throw 'Bạn không có quyền thực hiên.'

      transaction = Schema.transactions.findOne({_id: transactionId, merchant: profile.currentMerchant})
      if !transaction then throw 'Không tìm thấy transaction'
      if transaction.debitCash < depositCash then throw 'Tiền trả lớn hơn tiền thiếu.'
      if depositCash <= 0 then throw 'Tiền trả lớn hơn 0.'

      if Schema.transactionDetails.insert TransactionDetail.new(profile.user, transaction, depositCash, paymentDate)
        Schema.transactions.update transaction._id, $inc:{depositCash: depositCash, debitCash: -depositCash}
        if transaction.debitCash is depositCash
          Schema.transactions.update transaction._id, $set:{status:'closed', dueDay: new Date()}
        if transaction.group is 'customer' and transaction.allowDelete is true
          Schema.transactions.update transaction._id, $set: {allowDelete: false}
        if transaction.group is 'sale'
          Schema.sales.update transaction.parent, $inc: {deposit: depositCash, debit: -depositCash}
        if transaction.group is 'sale' or transaction.group is 'customer'
          Schema.customers.update transaction.owner, $inc:{totalDebit: -depositCash}

        MetroSummary.updateMetroSummaryByTransaction(profile.currentMerchant, depositCash)
      else throw 'Thêm trả nợ không thành công'

    catch error
      throw new Meteor.Error('addTransactionDetail', error)

  createCustomSale: (customSale)->
    latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
    if latestCustomSale
      if customSale.debtDate >= latestCustomSale.debtDate
        customSalesId =  Schema.customSales.insert customSale
        Schema.customSales.update latestCustomSale._id, $set:{allowDelete: false} if customSalesId
        for customSaleDetail in Schema.customSaleDetails.find({customSale: latestCustomSale._id}).fetch()
          Schema.customSaleDetails.update customSaleDetail._id, $set:{allowDelete: false}
    else Schema.customSales.insert customSale

  deleteCustomSale: (customSaleId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customSale = Schema.customSales.findOne({_id: customSaleId, parentMerchant: profile.parentMerchant})
        latestCustomSale  = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
        customer          = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
        customSaleDetails = Schema.customSaleDetails.find({customSale: customSale._id}).fetch()
        if customSale._id is latestCustomSale._id
          if customSaleDetails.length > 0
            incCustomerOption = {
              customSaleDebt     : -customSale.debtBalanceChange
              customSaleTotalCash: -customSale.debtBalanceChange
            }
            Schema.customers.update customer._id, $inc: incCustomerOption
            Schema.customSaleDetails.remove customSaleDetail._id for customSaleDetail in customSaleDetails
          Schema.customSales.remove customSale._id

          transactions = Schema.transactions.find({latestSale: customSale._id}).fetch()
          if transactions.length > 0
            incCustomerOption = {customSaleDebt: 0}
            for transaction in transactions
              incCustomerOption.customSaleDebt += transaction.debtBalanceChange
            Schema.customers.update customer._id, $inc: incCustomerOption

        else Schema.customSales.remove customSale._id if customSaleDetails.length is 0

        if latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
          Schema.customSales.update latestCustomSale._id, $set:{allowDelete: true}
          for customSaleDetail in Schema.customSaleDetails.find({customSale: latestCustomSale._id}).fetch()
            Schema.customSaleDetails.update customSaleDetail._id, $set:{allowDelete: true}

  updateCustomSaleByCreateCustomSaleDetail: (customSaleDetail)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customSale = Schema.customSales.findOne({_id: customSaleDetail.customSale, parentMerchant: profile.parentMerchant})
      latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
      if customSale._id is latestCustomSale._id
        if Schema.customSaleDetails.insert customSaleDetail
          incCustomSaleOption = {
            totalCash        : customSaleDetail.finalPrice
            debtBalanceChange: customSaleDetail.finalPrice
            latestDebtBalance: customSaleDetail.finalPrice
          }
          Schema.customSales.update customSaleDetail.customSale, $set:{allowDelete: false}, $inc: incCustomSaleOption

          customer = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
          incCustomerOption = {
            customSaleDebt     : customSaleDetail.finalPrice
            customSaleTotalCash: customSaleDetail.finalPrice
          }
          Schema.customers.update customer._id, $inc: incCustomerOption

          beforeDebtBalance = Schema.customSales.findOne(customSale._id).latestDebtBalance
          for transaction in Schema.transactions.find({latestSale: customSale._id}).fetch()
            latestDebtBalance = beforeDebtBalance - transaction.debtBalanceChange
            Schema.transactions.update transaction._id, $set: {beforeDebtBalance: beforeDebtBalance, latestDebtBalance: latestDebtBalance}
            beforeDebtBalance = latestDebtBalance



  updateCustomSaleByDeleteCustomSaleDetail: (customSaleDetailId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customSaleDetail = Schema.customSaleDetails.findOne({_id: customSaleDetailId, parentMerchant: profile.parentMerchant})
        customSale = Schema.customSales.findOne({_id: customSaleDetail.customSale, parentMerchant: profile.parentMerchant})
        latestCustomSale = Schema.customSales.findOne({buyer: customSale.buyer}, {sort: {debtDate: -1}})
        if customSale._id is latestCustomSale._id
          Schema.customSaleDetails.remove customSaleDetail._id
          setOption = {}
          setOption = {allowDelete: true} if Schema.customSaleDetails.findOne({customSale: customSale._id}) is undefined
          incCustomSaleOption = {
            totalCash        : -customSaleDetail.finalPrice
            debtBalanceChange: -customSaleDetail.finalPrice
            latestDebtBalance: -customSaleDetail.finalPrice
          }
          Schema.customSales.update customSaleDetail.customSale, $set: setOption, $inc: incCustomSaleOption

          customer = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
          incCustomerOption = {
            customSaleDebt     : -customSaleDetail.finalPrice
            customSaleTotalCash: -customSaleDetail.finalPrice
          }
          Schema.customers.update customer._id, $inc: incCustomerOption

          beforeDebtBalance = Schema.customSales.findOne(customSale._id).latestDebtBalance
          for transaction in Schema.transactions.find({latestSale: customSale._id}).fetch()
            latestDebtBalance = beforeDebtBalance - transaction.debtBalanceChange
            Schema.transactions.update transaction._id, $set: {beforeDebtBalance: beforeDebtBalance, latestDebtBalance: latestDebtBalance}
            beforeDebtBalance = latestDebtBalance
