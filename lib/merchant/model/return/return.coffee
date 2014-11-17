Schema.add 'returns', "Return", class Return
  @createBySale: (saleId)->
    return console.log("Phiếu bán hàng không tồn tại.") if !sale = Schema.sales.findOne({_id: saleId})
    return console.log("Không thể tạo phiếu trả hàng mới, phiếu trả hàng cũ chưa kết thúc.") if sale.status == false
    option =
      merchant       : sale.merchant
      warehouse      : sale.warehouse
      creator        : Meteor.userId()
      creatorName    : Meteor.user().emails[0].address
      sale           : sale._id
      comment        : 'Trả Hàng'
      returnCode     : "ramdom"
      productSale    : 0
      productQuality : 0
      discountCash   : 0
      discountPercent: 0
      totalPrice     : 0
      finallyPrice   : 0
      status         : 0
    option._id = Schema.returns.insert option
    Schema.sales.update sale._id, $set:{
      currentReturn : option._id
      returner      : Meteor.userId()
      status        : false
    }
    option