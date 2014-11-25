Apps.Merchant.customerManagementInit.push (scope) ->
  scope.createCustomSale = (event, template) ->
    $debtDate = template.ui.$debtDate
    $description = template.ui.$description
    debtDate = moment($debtDate.val(), 'DD/MM/YYYY')._d
    if $description.val().length > 0 and debtDate < (new Date)
      option =
        parentMerchant: Session.get('myProfile').currentMerchant
        creator       : Session.get('myProfile').user
        buyer         : Session.get("customerManagementCurrentCustomer")._id
        debtDate      : debtDate
        description   : $description.val()
      Schema.customSales.insert option

      $debtDate.val("")
      $description.val("")

  scope.deleteCustomSale = (customSaleId) ->
    customSale = Schema.customSales.findOne({_id: customSaleId, parentMerchant: Session.get('myProfile').currentMerchant})
    if customSale and customSale.allowDelete and customSale.depositCash is 0
      customSaleDetails = Schema.customSaleDetails.find({customSale: customSale._id})
      Schema.customSaleDetails.remove customSaleDetail._id for customSaleDetail in customSaleDetails.fetch()
      Schema.customSales.remove customSale._id


  scope.createCustomSaleDetail = (event, template) ->
    customSaleDetail =
      parentMerchant: Session.get('myProfile').currentMerchant
      creator       : Session.get('myProfile').user
      buyer         : Session.get("customerManagementCurrentCustomer")._id
      customSale    : "bFi7kn6G3xPDZBEud"
      productName   : 'Ao Quan'
      price         : 50000
      quality       : 10
      totalPrice    : 500000
    Schema.customSaleDetails.insert customSaleDetail

    customSaleOption = {totalCash: 0, depositCash: 0}
    for customSaleDetail in Schema.customSaleDetails.find({customSale: customSaleDetail.customSale}).fetch()
      customSaleOption.totalCash   += customSaleDetail.totalPrice
      customSaleOption.depositCash += customSaleDetail.totalPrice if customSaleDetail.pay is true
    Schema.customSales.update customSaleDetail.customSale, $set: customSaleOption

  scope.payCustomSaleDetail = (customSaleDetailId, pay) ->
    customSaleDetail = Schema.customSaleDetails.findOne({_id:customSaleDetailId, parentMerchant:Session.get('myProfile').parentMerchant})
    if customSaleDetail and customSaleDetail.pay is false and pay is true
      Schema.customSaleDetails.update customSaleDetail._id, $set:{pay: true}
      Schema.customSales.update customSaleDetail.customSale, $inc:{depositCash: customSaleDetail.totalPrice}

    if customSaleDetail and customSaleDetail.pay is true and pay is false
      Schema.customSaleDetails.update customSaleDetail._id, $set:{pay: false}
      Schema.customSales.update customSaleDetail.customSale, $inc:{depositCash: -customSaleDetail.totalPrice}

  scope.deleteCustomSaleDetail= (customSaleDetailId) ->
    customSaleDetail = Schema.customSaleDetails.findOne({_id:customSaleDetailId, parentMerchant:Session.get('myProfile').parentMerchant})
    if customSaleDetail and customSaleDetail.pay is false
      Schema.customSaleDetails.remove customSaleDetail._id
      Schema.customSales.update customSaleDetail.customSale, $inc:{totalCash: -customSaleDetail.totalPrice}