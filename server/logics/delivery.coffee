Meteor.methods
  updateDelivery: (deliveryId, success = true) ->
    if !userProfile = Schema.userProfiles.findOne({user: Meteor.userId()}) then return 'Bạn chưa đăng nhập'
    if !currentDelivery = Schema.deliveries.findOne({
      _id: deliveryId, merchant: userProfile.currentMerchant, warehouse: userProfile.currentWarehouse
    }) then return 'Phiếu giao hàng không tồn tại.'
    if !sale = Schema.sales.findOne(currentDelivery.sale) then return 'Phiếu Bán Hàng Không Có Giao Hàng'
    if sale.status == sale.submitted == true then return 'Phiếu Bán Hàng Đã Hoàn Thành, Không Thể Giao Hàng'

    switch currentDelivery.status
      when 1
        deliveryOption = {status: 2, shipper: Meteor.userId()}
        saleOption     = {status: true}
    #        Notification.deliveryNotify(sale._id, status: 'selected')
      when 3
        deliveryOption = {status: 4, shipper: Meteor.userId()}
    #        Notification.deliveryNotify(sale._id, status: 'working')
      when 4
      #thanh cong
        if success
          if sale.debit > 0
            deliveryOption = {status: 5, shipper: Meteor.userId()}
            saleOption     = {status: true, success: true}
          else
            deliveryOption = {status: 6, shipper: Meteor.userId()}
            saleOption     = {status: true, success: true}
    #          Notification.deliveryNotify(sale._id, status: 'success')
          #that bai
        else
          #TODO: Có vấn đề kho giao hàng thất bại (chưa biết tính cách trả tiền)
          if sale.debit > 0
            deliveryOption = {status: 8, shipper: Meteor.userId()}
            saleOption     = {status: true, success: false}
          else
            deliveryOption = {status: 8, shipper: Meteor.userId()}
            saleOption     = {status: true, success: false}
#          Notification.deliveryNotify(sale._id, status: 'fail')
    #xac nhan thanh cong
      when 6
        deliveryOption = {status: 7, shipper: Meteor.userId()}
        saleOption     = {status: true, submitted: true}
#        Notification.deliveryNotify(sale._id, status: 'done')
    #xac nhan that bai
      when 9
        deliveryOption = {status: 10, shipper: Meteor.userId()}
        saleOption     = {status: true, submitted: true}
    #        Notification.deliveryNotify(sale._id, status: 'done')

    Schema.deliveries.update currentDelivery._id, $set: deliveryOption
    Schema.sales.update currentDelivery.sale, $set: saleOption