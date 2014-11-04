logics.returns.editReturn = (returnId)->
  try
    throw 'Lỗi, Bạn chưa đăng nhập.' if !userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    throw 'Lỗi, Phiếu trả không chính xác.' if !currentReturn = Schema.returns.findOne({_id: returnId, creator: userProfile.user})
    if currentReturn.status == 1
      Schema.returns.update currentReturn._id, $set: {status: 0}
      for returnDetail in Schema.returnDetails.find({return: currentReturn._id, submit: true}).fetch()
        Schema.returnDetails.update returnDetail._id, $set: {submit: false}
      throw 'Ok, Phiếu đã có thể chỉnh sửa.'
    throw 'Lỗi, Phiếu chưa được xác nhận từ nhân viên.' if currentReturn.status == 0
    throw 'Lỗi, Phiếu đã được duyệt, không thể thao tác.' if currentReturn.status == 2
  catch error
    console.log error