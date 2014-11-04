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
      [] if !self.userId
      Schema.saleDetails.find {sale: saleId}
    children: [
      find: (saleDetai) -> Schema.products.find {_id: product}
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

Meteor.publish 'saleDetails', (saleId) ->
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