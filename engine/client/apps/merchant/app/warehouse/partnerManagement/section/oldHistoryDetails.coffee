lemon.defineWidget Template.partnerManagementOldHistoryDetails,
  quality: -> if @conversionQuality then @unitQuality else @importQuality
  importPrice: -> if @conversionQuality then @unitPrice else @importPrice
  totalPrice: -> if @conversionQuality then @unitQuality*@unitPrice else @importQuality*@importPrice

  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  finalReceivableClass: -> if @latestDebtBalance >= 0 then 'receive' else 'paid'

  oldHistoryDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find({import: importId})

  events:
    "click .enter-edit": (event, template) -> Session.set("distributorManagementCurrentCustomImport", @)
    "click .cancel-edit": (event, template) -> Session.set("distributorManagementCurrentCustomImport")

    "click .deleteCustomImport": (event, template) -> Meteor.call('deleteCustomImport', @_id)
    "click .deleteCustomImportDetail": (event, template) -> Meteor.call('updateCustomImportByDeleteCustomImportDetail', @_id)
    "click .deleteTransaction": (event, template) -> Meteor.call('deleteTransactionOfCustomImport', @_id)
