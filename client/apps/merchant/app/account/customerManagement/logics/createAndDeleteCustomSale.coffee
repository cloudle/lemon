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


  scope.createCustomSaleDetail = (customSale, template) ->
    $productName = $(template.find("[name='productName']"))
    $price       = $(template.find("[name='price']"))
    $quality     = $(template.find("[name='quality']"))
    $skulls      = $(template.find("[name='skulls']"))

    console.log customSale, $productName.val().length > 0, $skulls.val().length > 0, $price.val() > 0, $quality.val() > 0

    if customSale and $productName.val().length > 0 and $skulls.val().length > 0 and $price.val() > 0 and $quality.val() > 0
      customSaleDetail =
        parentMerchant: Session.get('myProfile').parentMerchant
        creator       : Session.get('myProfile').user
        buyer         : Session.get("customerManagementCurrentCustomer")._id
        customSale    : customSale._id
        productName   : $productName.val()
        skulls        : $skulls.val()
        price         : $price.val()
        quality       : $quality.val()
        finalPrice    : $quality.val()*$price.val()
      Schema.customSaleDetails.insert customSaleDetail

      customSaleOption = {totalCash: 0, depositCash: 0}
      for customSaleDetail in Schema.customSaleDetails.find({customSale: customSaleDetail.customSale}).fetch()
        customSaleOption.totalCash   += customSaleDetail.finalPrice
        customSaleOption.depositCash += customSaleDetail.finalPrice if customSaleDetail.pay is true
      Schema.customSales.update customSaleDetail.customSale, $set: customSaleOption
      $productName.val(''); $price.val(''); $quality.val(''); $skulls.val('')
  scope.payCustomSaleDetail = (customSaleDetailId, pay) ->

    customSaleDetail = Schema.customSaleDetails.findOne({_id:customSaleDetailId, parentMerchant:Session.get('myProfile').parentMerchant})
    if customSaleDetail and customSaleDetail.pay is false and pay is true
      Schema.customSaleDetails.update customSaleDetail._id, $set:{pay: true}
      Schema.customSales.update customSaleDetail.customSale, $set:{allowDelete: false}, $inc:{depositCash: customSaleDetail.finalPrice}

    if customSaleDetail and customSaleDetail.pay is true and pay is false
      Schema.customSaleDetails.update customSaleDetail._id, $set:{pay: false}
      customSale = Schema.customSales.findOne({_id:customSaleDetail.customSale, parentMerchant:Session.get('myProfile').parentMerchant})
      if customSale.depositCash is customSaleDetail.finalPrice
        Schema.customSales.update customSaleDetail.customSale, $set:{allowDelete: true, depositCash: 0}
      else
        Schema.customSales.update customSaleDetail.customSale, $inc:{depositCash: -customSaleDetail.finalPrice}

  scope.deleteCustomSaleDetail = (customSaleDetailId) ->
    customSaleDetail = Schema.customSaleDetails.findOne({_id:customSaleDetailId, parentMerchant:Session.get('myProfile').parentMerchant})
    customSale = Schema.customSales.findOne({_id:customSaleDetail.customSale, parentMerchant:Session.get('myProfile').parentMerchant})
    if customSaleDetail and customSaleDetail.pay is false
      Schema.customSaleDetails.remove customSaleDetail._id
      if customSale.depositCash is customSaleDetail.finalPrice
        Schema.customSales.update customSaleDetail.customSale, $set:{allowDelete: true, depositCash: 0}
      else
        Schema.customSales.update customSaleDetail.customSale, $inc:{totalCash: -customSaleDetail.finalPrice}