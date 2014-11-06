#Meteor.publish 'availableCustomers', ->
#  myProfile = Schema.userProfiles.findOne({user: @userId})
#  return [] if !myProfile
#  Schema.customers.find({parentMerchant: myProfile.parentMerchant})

Meteor.publishComposite 'availableCustomers',
  find: ->
    myProfile = Schema.userProfiles.findOne({user: @userId})
    return [] if !myProfile
    Schema.customers.find { parentMerchant: myProfile.parentMerchant }
  children: [
    find: (customer) -> AvatarImages.find {_id: customer.avatar}
  ]

Schema.customers.allow
  insert: -> true
  update: -> true
  remove: (userId, customer) ->
    anySaleFound = Schema.sales.findOne {buyer: customer._id}
    return anySaleFound is undefined