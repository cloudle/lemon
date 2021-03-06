Schema.add 'providers', "Provider", class Provider
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId}, {sort: {'version.createdAt': -1}})
  @insideBranch: (branchId) -> @schema.find({merchant: branchId}, {sort: {'version.createdAt': -1}})

  @findBy: (providerId, parentMerchantId = null)->
    if !parentMerchantId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.findOne({
      _id            : providerId
      parentMerchant : parentMerchantId ? myProfile.parentMerchant
    })

  @canDeleteByMe: () ->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      @schema.find
        parentMerchant: userProfile.parentMerchant
        creator       : userProfile.user
        allowDelete   : true


  @createNew: (name, phone, address)->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      provider =
        parentMerchant   : userProfile.parentMerchant
        merchant         : userProfile.currentMerchant
        creator          : userProfile.user
        name             : name
      provider.phone    = phone if phone
      provider.location = {address: [address]} if address

      findProvider =  Schema.providers.findOne({
        parentMerchant: provider.parentMerchant
        name          : provider.name
      })

      if findProvider
        {error:'Tên nhà cung cấp bị trùng lặp.'}
      else
        @schema.insert provider, (error, result)-> if error then {error: error} else {}

  @destroyByCreator: (providerId)->
    provider = @schema.findOne({_id: providerId , creator: Meteor.userId()})
    if provider.allowDelete
      @schema.remove(providerId)
      {}
    else
      {error:'Không thể xóa được nhà phân phối.'}

