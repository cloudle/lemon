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
  Schema.sales.find {}

Meteor.publish 'billManagerSale', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.sales.find {}

#return
Meteor.publish 'availableSales', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  sales = Schema.sales.find({
    merchant  : myProfile.currentMerchant,
    warehouse : myProfile.currentWarehouse,
    status    : true,
    submitted : true,
    returnLock: false})
  details = Schema.saleDetails.find({sale: {$in:_.pluck(sales.fetch(), '_id')}})
  [sales, details]


Meteor.publish 'saleBills', ->
  Schema.sales.find {}

Schema.sales.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.saleDetails.allow
  insert: -> true
  update: -> true
  remove: -> true