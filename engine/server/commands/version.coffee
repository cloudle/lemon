Meteor.methods
  versionUpdateBillNo: (profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      Schema.customers.find({parentMerchant: profile.parentMerchant}).forEach(
        (customer)->
          orderCode = '0000'
          Schema.sales.find({buyer: customer._id},{sort: {'version.createdAt': 1}}).forEach(
            (sale)->
              orderCode = Helpers.orderCodeCreate(orderCode)
              Schema.sales.update sale._id, $set:{orderCode: orderCode}
          )
          Schema.customers.update customer._id, $set:{billNo: orderCode}
      )

    catch error
      throw new Meteor.Error('reUpdateOrderCode', error)