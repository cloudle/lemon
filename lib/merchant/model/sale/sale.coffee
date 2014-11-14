createSaleCode = ->
  date = new Date()
  day = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  oldSale = Schema.sales.findOne({'version.createdAt': {$gt: day}},{sort: {'version.createdAt': -1}})
  if oldSale
    code = Number(oldSale.orderCode.substring(oldSale.orderCode.length-4))+1
    if 99 < code < 999 then code = "0#{code}"
    if 9 < code < 100 then code = "00#{code}"
    if code < 10 then code = "000#{code}"
    orderCode = "#{Helpers.FormatDate()}-#{code}"
  else
    orderCode = "#{Helpers.FormatDate()}-0001"
  orderCode



Schema.add 'sales', class Sale
  @newByOrder: (order)->
    option =
      merchant          : order.merchant
      warehouse         : order.warehouse
      creator           : order.creator
      seller            : order.seller
      buyer             : order.buyer
      orderCode         : createSaleCode()
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
      deposit           : order.deposit
      debit             : order.debit
      imported          : false
      exported          : false
      received          : false
      status            : false
      submitted         : false

  @insertByOrder: (order)->
    @schema.insert Sale.newByOrder(order), (error, result) ->
      if error then console.log error; null else result

  @findAccountingDetails: (starDate, toDate, warehouseId)->
    Schema.sales.find({$and: [
        { $or : [
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: starDate}
            'version.createdAt': {$lt: toDate}
            paymentsDelivery: 0
            status: true
            submitted: false
            exported: false
            imported: false
            received: false
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: starDate}
            'version.createdAt': {$lt: toDate}
            paymentsDelivery: 1
            status: true
            submitted: false
            exported: false
            imported: false
            received: false
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: starDate}
            'version.createdAt': {$lt: toDate}
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
            'version.createdAt': {$gt: starDate}
            'version.createdAt': {$lt: toDate}
            paymentsDelivery: 0
            status: true
            submitted: false
            exported: false
            imported: false
            received: true
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: starDate}
            'version.createdAt': {$lt: toDate}
            paymentsDelivery: 1
            status: true
            submitted: false
            exported: false
            imported: false
            received: true
          }
          {
            warehouse: warehouseId
            'version.createdAt': {$gt: starDate}
            'version.createdAt': {$lt: toDate}
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








