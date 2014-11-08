Meteor.methods
  updateDelivery: (deliveryId, status) ->
    if !userProfile = Schema.userProfiles.findOne({user: Meteor.userId()}) then return 'Bạn chưa đăng nhập'
    if !currentDelivery = Schema.deliveries.findOne({
      _id: deliveryId, merchant: userProfile.currentMerchant, warehouse: userProfile.currentWarehouse
    }) then return 'Phiếu giao hàng không tồn tại.'
    if !sale = Schema.sales.findOne(currentDelivery.sale) then return 'Phiếu Bán Hàng Không Có Giao Hàng'
    if sale.status == sale.submitted == true then return 'Phiếu Bán Hàng Đã Hoàn Thành, Không Thể Giao Hàng'

    setDeliveryOption = {}
    unsetDeliveryOption = {}
    setSaleOption = {}
    unsetSaleOption = {}
    switch status
      when 'cancel'
        if currentDelivery.status is 2 and currentDelivery.shipper is userProfile.user
          setDeliveryOption = {status: 1}
          unsetDeliveryOption = {shipper: true}
          setSaleOption     = {status: true}

        if currentDelivery.status is 4 and currentDelivery.shipper is userProfile.user
          setDeliveryOption = {status: 3}
#          setSaleOption     = {status: true}

        if currentDelivery.status is 8 and currentDelivery.shipper is userProfile.user
          setDeliveryOption = {status: 4}
          setSaleOption     = {status: true}
      when 'select'
        if currentDelivery.status is 1
          setDeliveryOption = {status: 2, shipper: userProfile.user}
          setSaleOption     = {status: true}
  #          Notification.deliveryNotify
      when 'start'
        if currentDelivery.status is 3
          setDeliveryOption = {status: 4, shipper: userProfile.user}
  #        Notification.deliveryNotify(sale._id, status: 'working')
      when 'success'
        if currentDelivery.status is 4
          if sale.debit > 0
            setDeliveryOption = {status: 5, shipper: userProfile.user}
            setSaleOption     = {status: true, success: true, submitted: true}
          else
            setDeliveryOption = {status: 7, shipper: userProfile.user}
            setSaleOption     = {status: true, success: true}
  #          Notification.deliveryNotify(sale._id, status: 'success')
  #          Notification.deliveryNotify(sale._id, status: 'done')
      when 'fail'
        if currentDelivery.status is 4
          if sale.debit > 0
            setDeliveryOption = {status: 8, shipper: userProfile.user}
            setSaleOption     = {status: true, success: false}
          else
            setDeliveryOption = {status: 8, shipper: userProfile.user}
            setSaleOption     = {status: true, success: false}
  #          Notification.deliveryNotify(sale._id, status: 'fail')
      when 'finish'
        if currentDelivery.status is 6
          setDeliveryOption = {status: 7, shipper: userProfile.user}
          setSaleOption     = {status: true, submitted: true}
#          Notification.deliveryNotify(sale._id, status: 'done')

        if currentDelivery.status is 9
          setDeliveryOption = {status: 10, shipper: userProfile.user}
          setSaleOption     = {status: true, submitted: true}
#          Notification.deliveryNotify(sale._id, status: 'done')

    Schema.deliveries.update currentDelivery._id, $set: setDeliveryOption, $unset: unsetDeliveryOption
    Schema.sales.update currentDelivery.sale, $set: setSaleOption, $unset: unsetSaleOption

