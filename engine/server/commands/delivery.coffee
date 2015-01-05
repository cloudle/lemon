Meteor.methods
  updateDelivery: (deliveryId, status) ->
    if !userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      throw new Meteor.Error('deliveryError', Apps.Merchant.DeliveryError.userNotFound.reason); return

    if !currentDelivery = Schema.deliveries.findOne({
      _id: deliveryId, merchant: userProfile.currentMerchant, warehouse: userProfile.currentWarehouse
    }) then throw new Meteor.Error('deliveryError', Apps.Merchant.DeliveryError.userNotFound.reason); return

    if !sale = Schema.sales.findOne(currentDelivery.sale)
      throw new Meteor.Error('deliveryError', Apps.Merchant.DeliveryError.saleNotDelivery.reason); return

    if sale.status == sale.submitted == true
      throw new Meteor.Error('deliveryError', Apps.Merchant.DeliveryError.deliveryIsFinish.reason); return

    transaction = Schema.transactions.findOne({parent: sale._id})

    setOptionDelivery   = {$set:{}}
    setOptionSale       = {$set:{}}
    unsetOptionSale     = {$unset:{}}
    unsetOptionDelivery = {$unset:{}}

    switch status
      when 'cancel'
        if currentDelivery.shipper is userProfile.user
          if currentDelivery.status is 2
            setOptionDelivery = {$set: {status: 1}}
            unsetOptionDelivery = {shipper: true}
            setOptionSale     = {$set: {status: false}}

          if currentDelivery.status is 4
            setOptionDelivery = {$set: {status: 3}}

          if currentDelivery.status is 5
            setOptionDelivery = {$set: {status: 4}}
            setOptionSale     = {$set: {status: false}}
            unsetOptionSale   = {$unset:{success: true}}

          if currentDelivery.status is 8
            setOptionDelivery = {$set: {status: 4}}
            setOptionSale     = {$set: {status: false}}

      when 'select'
        if currentDelivery.status is 1
          setOptionDelivery = {$set: {status: 2, shipper: userProfile.user}}
          setOptionSale     = {$set: {status: true}}
          Meteor.call 'deliveryNotify', userProfile, sale._id, status

      when 'start'
        if currentDelivery.status is 3
          setOptionDelivery = {$set: {status: 4, shipper: userProfile.user}}
          Meteor.call 'deliveryNotify', userProfile, sale._id, status

      when 'success'
        if currentDelivery.status is 4
          if transaction.debitCash > 0
            setOptionDelivery = {$set: {status: 5, shipper: userProfile.user}}
            setOptionSale     = {$set: {status: true, success: true}}
          else
            setOptionDelivery = {$set: {status: 7, shipper: userProfile.user}}
            setOptionSale     = {$set: {status: false, success: true, submitted: true}}
          Meteor.call 'deliveryNotify', userProfile, sale._id, status

      when 'fail'
        if currentDelivery.status is 4
          if transaction.debitCash > 0
            setOptionDelivery = {$set: {status: 8, shipper: userProfile.user}}
            setOptionSale     = {$set: {status: true, success: false}}
          else
            setOptionDelivery = {$set: {status: 8, shipper: userProfile.user}}
            setOptionSale     = {$set: {status: true, success: false}}
          Meteor.call 'deliveryNotify', userProfile, sale._id, status


      when 'finish'
        if currentDelivery.status is 6
          setOptionDelivery = {$set: {status: 7, shipper: userProfile.user}}
          setOptionSale     = {$set: {status: true, submitted: true}}
        if currentDelivery.status is 9
          setOptionDelivery = {$set: {status: 10, shipper: userProfile.user}}
          setOptionSale     = {$set: {status: true, submitted: true}}
        Meteor.call 'deliveryNotify', userProfile, sale._id, status

    Schema.deliveries.update currentDelivery._id, setOptionDelivery, unsetOptionDelivery
    Schema.sales.update currentDelivery.sale, setOptionSale , unsetOptionSale

