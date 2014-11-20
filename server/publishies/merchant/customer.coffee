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

Meteor.publish 'availableCustomerAreas', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.customerAreas.find({parentMerchant: myProfile.parentMerchant})

Schema.customers.allow
  insert: (userId, customer) ->
    customerFound = Schema.customers.findOne({currentMerchant: customer.parentMerchant, name: customer.name, description: customer.description})
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


Schema.customerAreas.allow
  insert: -> true
  update: -> true
  remove: (userId, customerArea)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      anyCustomerFound = Schema.customers.findOne {parentMerchant: profile.parentMerchant, areas: {$elemMatch: {$in:[customerArea._id]}}}
      return anyCustomerFound is undefined