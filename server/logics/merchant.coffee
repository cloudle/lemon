Meteor.methods
  registerMerchant: (email, password, companyName, contactPhone) ->
    userId = Accounts.createUser {email: email, password: password}
    user = Meteor.users.findOne(userId)

    if !user
      throw new Meteor.Error("loi tao tai khoan", "khong the tao tai khoan")
      return

    Schema.userProfiles.insert UserProfile.newDefault(userId), (error, result)-> console.log error if error
    Schema.merchantPurchases.insert({merchantRegistered: false, user: userId, companyName: companyName, companyPhone: contactPhone})
    return user