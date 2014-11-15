#Meteor.publish 'availableCustomers', ->
#  myProfile = Schema.userProfiles.findOne({user: @userId})
#  return [] if !myProfile
#  Schema.customers.find({parentMerchant: myProfile.parentMerchant})

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

Schema.customers.allow
  insert: (userId, customer) ->
    customerFound = Schema.customers.findOne({currentMerchant: customer.parentMerchant, name: customer.name, phone: customer.phone})
    return customerFound is undefined

#    if profile = Schema.userProfiles.findOne({user: userId})
#      if customer.parentMerchant is profile.parentMerchant and customer.creator is profile.user
#        if !Schema.customers.findOne({
#          currentMerchant: customer.parentMerchant
#          name: customer.name
#          phone: customer.phone}) then true

  update: -> true
  remove: (userId, customer) ->
    anySaleFound = Schema.sales.findOne {buyer: customer._id}
    return anySaleFound is undefined