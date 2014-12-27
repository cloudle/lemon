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


  @createByCustomer: (customer, myProfile)->
    if !myProfile then myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    option =
      merchant       : myProfile.currentMerchant
      warehouse      : myProfile.currentWarehouse
      creator        : myProfile.user
      customer       : customer._id
      returnCode     : "ramdom"
      discountCash   : 0
      discountPercent: 0
      totalPrice     : 0
      finallyPrice   : 0
      status         : 0
      returnMethods  : 0
      tabDisplay     : Helpers.shortName2(customer.name)
      beforeDebtBalance: 0
      debtBalanceChange: 0
      latestDebtBalance: 0
    option._id = Schema.returns.insert option
    option

  @createByDistributor: (distributor, myProfile)->
    if !myProfile then myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    option =
      merchant       : myProfile.currentMerchant
      warehouse      : myProfile.currentWarehouse
      creator        : myProfile.user
      distributor    : distributor._id
      returnCode     : "ramdom"
      discountCash   : 0
      discountPercent: 0
      totalPrice     : 0
      finallyPrice   : 0
      status         : 0
      returnMethods  : 1
      tabDisplay     : Helpers.shortName2(distributor.name)
      beforeDebtBalance: 0
      debtBalanceChange: 0
      latestDebtBalance: 0
    option._id = Schema.returns.insert option
    option