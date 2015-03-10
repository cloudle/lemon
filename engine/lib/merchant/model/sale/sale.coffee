Schema.add 'sales', "Sale", class Sale
  @newByOrder: (order)->
    buyer = Schema.customers.findOne(order.buyer)
    option =
      parentMerchant    : order.parentMerchant
      merchant          : order.merchant
      warehouse         : order.warehouse
      creator           : order.creator
      seller            : order.seller
      buyer             : order.buyer
      orderCode         : Helpers.createSaleCode(buyer._id)
      productCount      : order.productCount
      saleCount         : order.saleCount
      return            : false
      returnLock        : false
      returnCount       : 0
      returnQuality     : 0
      paymentMethod     : order.paymentMethod
      paymentsDelivery  : order.paymentsDelivery
      billDiscount      : order.billDiscount
      discountCash      : order.discountCash
      totalPrice        : order.totalPrice
      finalPrice        : order.finalPrice
      deposit           : order.currentDeposit
      debit             : order.debit
      imported          : false
      exported          : false
      received          : false
      status            : false
      submitted         : false

      debtBalanceChange : order.finalPrice
      beforeDebtBalance : buyer.saleDebt
      latestDebtBalance : buyer.saleDebt + order.finalPrice

    option.description = order.description if order.description
    return option

  @insertByOrder: (order)->
    @schema.insert Sale.newByOrder(order), (error, result) -> if error then console.log error; null else result

  @findAccountingDetails: (starDate, toDate, warehouseId)->
    Schema.sales.find({$and: [
        { $or : [
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}
            'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}
            paymentsDelivery: 0
            status: true
            submitted: false
            exported: false
            imported: false
            received: false
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}
            'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}
            paymentsDelivery: 1
            status: true
            submitted: false
            exported: false
            imported: false
            received: false
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}
            'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}
            paymentsDelivery: 1
            status: true
            submitted: false
            exported: true
            imported: false
            received: true
            success : true
          }
        ]}
      ]})

  @findBillDetails: (starDate, toDate, warehouseId)->
    Schema.sales.find({$and: [
        {warehouse: warehouseId}
        {'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}}
        {'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}}
      ]})

  @findExportAndImport: (starDate, toDate, warehouseId)->
    Schema.sales.find({$and: [
        { $or : [
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}
            'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}
            paymentsDelivery: 0
            status: true
            submitted: false
            exported: false
            imported: false
            received: true
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}
            'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}
            paymentsDelivery: 1
            status: true
            submitted: false
            exported: false
            imported: false
            received: true
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: new Date(starDate.getFullYear(), starDate.getMonth(), starDate.getDate())}
            'version.createdAt': {$lt: new Date(toDate.getFullYear(), toDate.getMonth(), toDate.getDate()+1)}
            paymentsDelivery: 1
            status: true
            submitted: false
            exported: true
            imported: false
            received: true
            success : false
          }
        ]}
      ]})

  @findAvailableReturn: (myProfile)->
    if !myProfile then myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    Schema.sales.find({
      merchant : myProfile.currentMerchant
      warehouse: myProfile.currentWarehouse
      submitted: true
      returnLock: false})








