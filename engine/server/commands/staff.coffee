Meteor.methods
  staffToSales: (profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      orderFound = Schema.orders.findOne({creator: userId, merchant: profile.currentMerchant}, {sort: {'version.createdAt': -1}})
      if !orderFound then orderFound = Order.createdNewBy(undefined, profile)
      Schema.userSessions.update {user: userId}, {$set:{currentOrder: orderFound._id}}

    catch error
      throw new Meteor.Error('staffToSales', error)
