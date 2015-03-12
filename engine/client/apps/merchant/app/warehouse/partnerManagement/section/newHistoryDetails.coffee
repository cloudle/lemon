lemon.defineWidget Template.partnerManagementNewHistoryDetails,
  quality: -> if @conversionQuality then @unitQuality else @importQuality
  importPrice: -> if @conversionQuality then @unitPrice else @importPrice
  totalPrice: -> if @conversionQuality then @unitQuality*@unitPrice else @importQuality*@importPrice

  receivableClass     : -> if @receivable then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'
  showSubmitHistory: -> if @first then true else false
  showUnSubmit: -> if @status is 'unSubmit' then true else false
  isTransaction: -> if @group then true else false
  description: -> if @description then @description else if @partnerImport then 'Phiếu bán' else 'Phiếu nhập'


  newHistoryDetails: ->
    Id = UI._templateInstance().data._id
    importList = Schema.productDetails.find({import: Id}).fetch()
    saleList = Schema.partnerSaleDetails.find({partnerSales: Id}).fetch()
    importList.concat(saleList)


  events:
    "click .deleteHistory": (event, template) -> Meteor.call('partnerDeleteHistory', @)
    "click .submitHistory": (event, template) -> Meteor.call('submitPartnerSale', @_id)
    "click .deleteTransaction": (event, template) -> Meteor.call('deletePartnerTransaction', @_id)
    "click .submitTransaction": (event, template) -> Meteor.call('submitPartnerTransaction', @_id)


