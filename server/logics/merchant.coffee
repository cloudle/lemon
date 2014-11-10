Meteor.methods
  registerMerchant: (email, password) ->
    Accounts.createUser {email: email, password: password}