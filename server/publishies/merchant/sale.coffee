Meteor.publish 'mySaleAndDetail', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  mySales = Schema.sales.find({
    $and :
      [
        {merchant: myProfile.currentMerchant, warehouse: myProfile.currentWarehouse}
        ,
        {$or:[{creator: myProfile.user}, {seller: myProfile.user}]}
      ]
    })

  mySaleDetails = Schema.saleDetails.find({sale: {$in:_.pluck(mySales.fetch(), '_id')}})

  [mySales, mySaleDetails]


Schema.sales.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.saleDetails.allow
  insert: -> true
  update: -> true
  remove: -> true