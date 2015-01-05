logics.returns.finishReturn = (returnId)->
  try
    throw 'Lỗi, Bạn chưa đăng nhập.' if !userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    throw 'Lỗi, Phiếu trả không chính xác.' if !currentReturn = Schema.returns.findOne({_id: returnId, creator: userProfile.user})
    throw 'Lỗi, Phiếu trả hàng rỗng, không thể xác nhận.' if Schema.returnDetails.find({return: currentReturn._id}).count() < 1
#    throw 'Lỗi, Bạn không có quyền.' unless Role.hasPermission(userProfile._id, Sky.system.merchantPermissions.returnCreate.key)
    if currentReturn.status == 0
      Meteor.call 'returnConfirm', userProfile, returnId
      Schema.returns.update currentReturn._id, $set: {status: 1}
      for returnDetail in Schema.returnDetails.find({return: currentReturn._id, submit: false}).fetch()
        Schema.returnDetails.update returnDetail._id, $set: {submit: true}
      throw 'Ok, Phiếu đã được xác nhận từ nhân viên'
    throw 'Lỗi, Phiếu đã được xác nhận, đang chờ duyệt, không thể thao tác.' if currentReturn.status == 1
    throw 'Lỗi, Phiếu đã được duyệt, không thể thao tác.' if currentReturn.status == 2
  catch error
    console.log error