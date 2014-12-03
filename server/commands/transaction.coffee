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


  createNewReceiptCashOfSales: (customerId, debtCash, description, paidDate)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customer = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
        sale = Schema.sales.findOne({buyer: customer._id},{sort: {'version.createdAt': -1}})

        option =
          parentMerchant: profile.parentMerchant
          merchant      : profile.currentMerchant
          warehouse     : profile.currentWarehouse
          creator       : profile.user
          owner         : customer._id
          latestSale    : sale._id if sale
          group         : 'sales'
          debtDate      : paidDate if paidDate
          totalCash     : debtCash

        incCustomerOption = {saleDebt: -debtCash }
        if debtCash > 0
          option.description = if description?.length > 0 then description else 'Thu Tiền'
          option.receivable  = true
          incCustomerOption.salePaid = debtCash
        else
          option.description = if description?.length > 0 then description else 'Cho Mượn Tiền'
          option.receivable  = false
          incCustomerOption.saleTotalCash = -debtCash

        option.debtBalanceChange = debtCash
        option.beforeDebtBalance = customer.saleDebt
        option.latestDebtBalance = customer.saleDebt - debtCash

        Schema.transactions.insert option
        Schema.customers.update customer._id, $inc: incCustomerOption

  createNewReceiptCashOfCustomSale: (customerId, debtCash, description, paidDate)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customer = Schema.customers.findOne({_id: customerId, parentMerchant: profile.parentMerchant})
      if customer and customer.customSaleModeEnabled is true and paidDate < (new Date)
        latestCustomSale = Schema.customSales.findOne({buyer: customer._id},{sort: {debtDate: -1}})
        if latestCustomSale is undefined
          option =
            parentMerchant   : profile.currentMerchant
            creator          : profile.user
            buyer            : customer._id
            debtDate         : paidDate
            description      : ''
            debtBalanceChange: 0
            beforeDebtBalance: customer.customSaleDebt
            latestDebtBalance: customer.customSaleDebt
          Meteor.call('createCustomSale', option)
          latestCustomSale = Schema.customSales.findOne({buyer: customer._id},{sort: {debtDate: -1}})

        if paidDate >= latestCustomSale.debtDate
          option =
            parentMerchant: profile.parentMerchant
            merchant      : profile.currentMerchant
            warehouse     : profile.currentWarehouse
            creator       : profile.user
            owner         : customer._id
            latestSale    : latestCustomSale._id
            group         : 'customSale'
            debtDate      : paidDate if paidDate
            totalCash     : debtCash

          incCustomerOption = {customSaleDebt: -debtCash }
          if debtCash > 0
            option.description = if description?.length > 0 then description else 'Thu Tiền'
            option.receivable  = true
            incCustomerOption.customSalePaid= debtCash
          else
            option.description = if description?.length > 0 then description else 'Cho Mượn Tiền'
            option.receivable  = false
            incCustomerOption.customSaleTotalCash = -debtCash

          option.debtBalanceChange = debtCash
          option.beforeDebtBalance = customer.customSaleDebt
          option.latestDebtBalance = customer.customSaleDebt - debtCash

          latestTransaction = Schema.transactions.findOne({owner: customer._id, latestSale: latestCustomSale._id, parentMerchant: profile.parentMerchant}, {sort: {debtDate: -1}})
          Schema.transactions.update latestTransaction._id, $set:{allowDelete: false} if latestTransaction

          Schema.transactions.insert option
          Schema.customSales.update latestCustomSale._id, $set:{allowDelete: false}
          Schema.customers.update customer._id, $inc: incCustomerOption

  deleteTransactionOfCustomSale: (transactionId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if transaction = Schema.transactions.findOne({_id: transactionId, parentMerchant: profile.parentMerchant})
        customer = Schema.customers.findOne({_id: transaction.owner, parentMerchant: profile.parentMerchant})
        if customer.customSaleModeEnabled is true
          latestCustomSale = Schema.customSales.findOne({buyer: transaction.owner}, {sort: {debtDate: -1}})
          latestTransaction = Schema.transactions.findOne({owner: transaction.owner, group: 'customSale', parentMerchant: profile.parentMerchant}, {sort: {debtDate: -1}})

          if transaction.latestSale is latestCustomSale._id and transaction._id is latestTransaction._id
            incCustomerOption = {customSaleDebt: transaction.debtBalanceChange }
            if transaction.debtBalanceChange > 0
              incCustomerOption.customSalePaid = transaction.debtBalanceChange
            else
              incCustomerOption.customSaleTotalCash = transaction.debtBalanceChange
            Schema.customers.update transaction.owner, $inc: incCustomerOption
            Schema.transactions.remove transaction._id

            latestTransaction = Schema.transactions.findOne({latestSale: transaction.latestSale, parentMerchant: profile.parentMerchant}, {sort: {debtDate: -1}})
            if latestTransaction
              Schema.transactions.update latestTransaction._id, $set:{allowDelete: true}
            else
              Schema.customSales.update latestCustomSale._id, $set:{allowDelete: true}
