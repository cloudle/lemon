Schema.add 'distributors', "Distributor", class Distributor
  @insideMerchant: (merchantId) -> @schema.find({parentMerchant: merchantId})
  @canDeleteByMe: () ->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      @schema.find
        parentMerchant: userProfile.parentMerchant
        creator       : userProfile.user
        allowDelete   : true

  @createNew: (name, phone, address)->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      distributor =
        parentMerchant   : userProfile.parentMerchant
        merchant         : userProfile.currentMerchant
        creator          : userProfile.user
        name             : name
        phone            : phone if phone
        location         : {address: [address]} if address

      findDistributor =  Schema.providers.findOne({
        parentMerchant: distributor.parentMerchant
        name          : distributor.name
      })

      if findDistributor
        {error:'Tên nhà phân phối bị trùng lặp.'}
      else
        @schema.insert distributor, (error, result)-> if error then {error: error} else {}