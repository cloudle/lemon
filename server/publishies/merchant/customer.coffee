Meteor.publishComposite 'availableCustomers', ->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.customers.find {parentMerchant: myProfile.parentMerchant}
    children: [
      find: (customer) -> AvatarImages.find {_id: customer.avatar}
    ]
  }

Meteor.publish 'availableCustomerAreas', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.customerAreas.find({parentMerchant: myProfile.parentMerchant})

Meteor.publishComposite 'customerManagementData', (customerId, currentRecords = 0, limitRecords = 5)->
  self = @
  salesCount = Schema.sales.find({buyer: customerId}, {sort: {'version.createdAt': 1}}).count()
  customSalesCount = Schema.customSales.find({buyer: customerId}, {sort: {debtDate: 1}}).count()

  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.customers.find {_id: customerId, parentMerchant: myProfile.parentMerchant}
    children: [
      find: (customer) ->
        if customer.customSaleModeEnabled
          if customSalesCount > currentRecords
            skipCustomSaleRecords  = currentRecords
            limitCustomSaleRecords = limitRecords
          else
            skipCustomSaleRecords  = customSalesCount
            limitCustomSaleRecords = 0
          Schema.customSales.find {buyer: customer._id}, {sort: {debtDate: -1}, skip: skipCustomSaleRecords, limit: limitCustomSaleRecords}
        else
          if salesCount < currentRecords + limitRecords
            if salesCount + limitRecords > currentRecords
              skipCustomSaleRecords  = 0
              limitCustomSaleRecords = limitRecords + currentRecords - salesCount
            else
              skipCustomSaleRecords  = currentRecords - salesCount
              limitCustomSaleRecords = limitRecords
            Schema.customSales.find {buyer: customer._id}, {sort: {debtDate: -1}, skip: skipCustomSaleRecords, limit: limitCustomSaleRecords}
          else
            EmptyQueryResult
      children: [
        find: (customSale, customer) -> Schema.customSaleDetails.find {customSale: customSale._id}
      ,
        find: (customSale, customer) -> Schema.transactions.find {latestSale: customSale._id}
      ]
    ,
      find: (customer) ->
        if customer.customSaleModeEnabled
          Schema.sales.find {buyer: customer._id}
        else
          if salesCount > currentRecords
            skipSaleRecords  = currentRecords
            limitSaleRecords = limitRecords
            Schema.sales.find {buyer: customer._id}, {sort: {'version.createdAt': -1}, skip: skipSaleRecords, limit: limitSaleRecords}
          else
            EmptyQueryResult
      children: [
        find: (sale, customer) -> Schema.saleDetails.find {sale: sale._id}
        children: [
          find: (saleDetail, customer) -> Schema.products.find {_id: saleDetail.product}
        ]
      ,
        find: (sale, customer) -> Schema.returns.find {sale: sale._id}
        children: [
          find: (returns, customer) -> Schema.returnDetails.find {return: returns._id}
        ]
      ,
        find: (sale, customer) -> Schema.transactions.find {latestSale: sale._id}
      ]
    ]
  }


Schema.customers.allow
  insert: (userId, customer) ->
    customerFound = Schema.customers.findOne({currentMerchant: customer.parentMerchant, name: customer.name, description: customer.description})
    return customerFound is undefined
  update: -> true
  remove: (userId, customer) ->
    anySaleFound = Schema.sales.findOne {buyer: customer._id}
    anyCustomSaleFound = Schema.customSales.findOne {buyer: customer._id}
    anyTransactionFound = Schema.transactions.findOne {owner: customer._id}
    return anySaleFound is undefined and anyTransactionFound is undefined and anyCustomSaleFound is undefined


Schema.customerAreas.allow
  insert: -> true
  update: -> true
  remove: (userId, customerArea)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      anyCustomerFound = Schema.customers.findOne {parentMerchant: profile.parentMerchant, areas: {$elemMatch: {$in:[customerArea._id]}}}
      return anyCustomerFound is undefined