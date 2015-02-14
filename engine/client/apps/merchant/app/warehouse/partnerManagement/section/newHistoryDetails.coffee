lemon.defineWidget Template.partnerManagementNewHistoryDetails,
  quality: -> if @conversionQuality then @unitQuality else @importQuality
  importPrice: -> if @conversionQuality then @unitPrice else @importPrice
  totalPrice: -> if @conversionQuality then @unitQuality*@unitPrice else @importQuality*@importPrice

  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'
  showSubmitHistory: -> if @partnerImport then true else false

  newHistoryDetails: ->
    Id = UI._templateInstance().data._id
    importList = Schema.productDetails.find({import: Id}).fetch()
    saleList = Schema.partnerSaleDetails.find({partnerSales: Id}).fetch()
    importList.concat(saleList)


  events:
    "click .deleteHistory": (event, template) -> Meteor.call('partnerDeleteHistory', @)
    "click .submitHistory": (event, template) -> Meteor.call('submitPartnerSale', @_id)

