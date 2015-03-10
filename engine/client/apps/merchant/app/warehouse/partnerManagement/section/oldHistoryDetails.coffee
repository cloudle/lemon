lemon.defineWidget Template.partnerManagementOldHistoryDetails,
  quality    : -> if @conversionQuality then @unitQuality else @importQuality
  importPrice: -> if @conversionQuality then @unitPrice else @importPrice
  totalPrice : -> if @conversionQuality then @unitQuality*@unitPrice else @importQuality*@importPrice
  bill: -> if @partnerSale then 'Phiếu nhập' else 'Phiếu bán'
  description: ->
    if @description is 'Trả Tiền'
      @description + ' cho ' + Session.get("partnerManagementCurrentPartner").name
    else if @description is 'Thu Tiền'
      @description + ' từ ' + Session.get("partnerManagementCurrentPartner").name
    else
      @description

  isTransaction: -> if @group then true else false

  receivableClass     : -> if @receivable then 'receive' else 'paid'
  finalReceivableClass: -> if @latestDebtBalance > 0 then 'receive' else 'paid'
  isTransaction       : -> if @group then true else false

  oldHistoryDetails: ->
    Id = UI._templateInstance().data._id
    importList = Schema.productDetails.find({import: Id}).fetch()
    saleList = Schema.partnerSaleDetails.find({partnerSales: Id}).fetch()
    importList.concat(saleList)

  events:
    "click .enter-edit": (event, template) -> Session.set("distributorManagementCurrentCustomImport", @)
    "click .cancel-edit": (event, template) -> Session.set("distributorManagementCurrentCustomImport")

    "click .deleteCustomImport": (event, template) -> Meteor.call('deleteCustomImport', @_id)
    "click .deleteCustomImportDetail": (event, template) -> Meteor.call('updateCustomImportByDeleteCustomImportDetail', @_id)
    "click .deleteTransaction": (event, template) -> Meteor.call('deleteTransactionOfCustomImport', @_id)
