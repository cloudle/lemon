Schema.add 'customerAreas', "CustomerArea", class CustomerArea
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})

  @canDeleteByMe: () ->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      @schema.find
        parentMerchant: userProfile.parentMerchant
        creator       : userProfile.user
        allowDelete   : true

  @destroyByCreator: (id) ->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customerArea = @schema.findOne({_id: id, parentMerchant: userProfile.parentMerchant, creator: userProfile.user, allowDelete: true})
      if customerArea then @schema.remove(id); {}
      else {error:'Không thể xóa được khu vực.'}