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

  deleteCustomSale: (customSaleId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customSale = Schema.customSales.findOne({_id: customSaleId, parentMerchant: profile.parentMerchant})
      if customSale and customSale.allowDelete is false
        customer          = Schema.customers.findOne({_id: customSale.buyer, parentMerchant: profile.parentMerchant})
        customSaleDetails = Schema.customSaleDetails.find({customSale: customSale._id}).fetch()
        if customSaleDetails.length > 0
          incCustomerOption = {
            customSaleDebt     : -customSale.finalPrice
            customSaleTotalCash: -customSale.finalPrice
          }
          Schema.customers.update customer._id, $inc: incCustomerOption
          Schema.customSaleDetails.remove customSaleDetail._id for customSaleDetail in customSaleDetails
        Schema.customSales.remove customSale._id

#        transactions = Schema.transactions.find({latestSale: customSale._id}).fetch()
#        if transactions.length > 0
#          incCustomerOption = {customSaleDebt: 0}
#          for transaction in transactions
#          Schema.customers.update customer._id, $inc: incCustomerOption



  updateCustomSaleByCreateCustomSaleDetail: (customSaleDetailId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customSaleDetail = Schema.customSaleDetails.findOne({_id: customSaleDetailId, parentMerchant: profile.parentMerchant})
        customSale = Schema.customSales.findOne({_id: customSaleDetail.customSale, parentMerchant: profile.parentMerchant})
        if customSale.confirm is false
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

  updateCustomSaleByDeleteCustomSaleDetail: (customSaleDetailId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customSaleDetail = Schema.customSaleDetails.findOne({_id: customSaleDetailId, parentMerchant: profile.parentMerchant})
        customSale = Schema.customSales.findOne({_id: customSaleDetail.customSale, parentMerchant: profile.parentMerchant})
        if customSale.confirm is false
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
