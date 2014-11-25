Meteor.publishComposite 'availableSaleOf', (customerId)->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      allMerchants = Schema.merchants.find({$or:[{_id: myProfile.parentMerchant }, {parent: myProfile.parentMerchant}]})
      Schema.sales.find {buyer: customerId, merchant: $in: _.union(_.pluck(allMerchants.fetch(), '_id'))}
    children: [
      find: (sale) -> Schema.saleDetails.find {sale: sale._id}
      children: [
        find: (saleDetail, sale) -> Schema.products.find {_id: saleDetail.product}
      ]
    ]
  }

Meteor.publish 'mySaleAndDetail', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  mySales = Schema.sales.find({
    $and :
      [
        {merchant: myProfile.currentMerchant, warehouse: myProfile.currentWarehouse}
        {$or:[{creator: myProfile.user}, {seller: myProfile.user}]}
      ]
    })
  mySaleDetails = Schema.saleDetails.find({sale: {$in:_.pluck(mySales.fetch(), '_id')}})
  [mySales, mySaleDetails]

Meteor.publish 'saleBillAccounting', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  date = new Date()
  firstDay = new Date(date.getFullYear(), date.getMonth(), 15)
  lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0)
  Sale.findAccountingDetails(firstDay, lastDay, myProfile.currentWarehouse)

Meteor.publishComposite 'billManagerSales', ->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.sales.find {merchant: myProfile.currentMerchant}
    children: [
      find: (sale) -> Schema.customers.find {_id: sale.buyer}
      children: [
        find: (customer, sale) -> AvatarImages.find {_id: customer.avatar}
      ]
    ]
  }

Meteor.publish 'saleBills', ->
  Schema.sales.find {}

#Return----------------------------------------
Meteor.publish 'availableSales', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.sales.find({
    merchant  : myProfile.currentMerchant,
    warehouse : myProfile.currentWarehouse,
    submitted : true,
    returnLock: false})

Meteor.publishComposite 'saleDetails', (saleId) ->
  self = @
  return {
    find: ->
      return EmptyQueryResult if !self.userId
      Schema.saleDetails.find {sale: saleId}
    children: [
      find: (saleDetail) -> Schema.products.find {_id: saleDetail.product}
    ]
  }

#Meteor.publishComposite 'myMerchantContacts',
#  find: ->
#    currentProfile = Schema.userProfiles.findOne({user: @userId})
#    return [] if !currentProfile
#    Schema.userProfiles.find { currentMerchant: currentProfile.currentMerchant }
#  children: [
#    find: (profile) -> Meteor.users.find {_id: profile.user}
#  ,
#    find: (profile) -> AvatarImages.find {_id: profile.avatar}
#  ]

Meteor.publish 'saleDetailAndProductAndReturn', (saleId) ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  if Schema.sales.findOne({_id: saleId, merchant: myProfile.currentMerchant, warehouse: myProfile.currentWarehouse})
    saleDetail = Schema.saleDetails.find {sale: saleId}
    returnProducts = Schema.products.find {_id: {$in:_.pluck(saleDetail.fetch(), 'product')}}
    returns = Schema.returns.find {sale: saleId, status: {$ne: 2}}

    [saleDetail, returnProducts, returns]

Schema.sales.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.saleDetails.allow
  insert: -> true
  update: -> true
  remove: -> true