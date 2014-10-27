Meteor.publish 'sales', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.sales.find({
    $and :
      [
        {merchant: myProfile.currentMerchant, warehouse: myProfile.currentWarehouse}
        ,
        {$or:[{creator: myProfile.user}, {seller: myProfile.user}]}
      ]
    })


Schema.sales.allow
  insert: -> true
  update: -> true
  remove: -> true