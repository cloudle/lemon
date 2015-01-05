Meteor.publishComposite 'availableDeliveries', ->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.deliveries.find { merchant: myProfile.currentMerchant }
    children: [
      find: (delivery) -> Schema.customers.find { _id: delivery.buyer }
      children: [
        find: (customer, delivery) -> AvatarImages.find {_id: customer.avatar}
      ]
    ]
  }

Schema.deliveries.allow
  insert: -> true
  update: -> true
  remove: -> true