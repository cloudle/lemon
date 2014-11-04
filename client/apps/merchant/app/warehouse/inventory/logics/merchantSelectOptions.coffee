
#formatMerchantSearch = (item) -> "#{item.name}" if item
#  merchantSelectOptions:
#    query: (query) -> query.callback
#      results: _.filter Session.get('allMerchantInventories'), (item) ->
#        unsignedTerm = Sky.helpers.removeVnSigns query.term
#        unsignedName = Sky.helpers.removeVnSigns item.name
#        unsignedName.indexOf(unsignedTerm) > -1
#    initSelection: (element, callback) -> callback(Session.get('inventoryMerchant') ? 'skyReset')
#    formatSelection: formatMerchantSearch
#    formatResult: formatMerchantSearch
#    placeholder: 'CHỌN CHI NHÁNH'
#    changeAction: (e) ->
#      Schema.userProfiles.update Session.get('currentProfile')._id, $set:
#        inventoryMerchant : e.added._id
#        inventoryWarehouse: Schema.warehouses.findOne(merchant: e.added._id)?._id  ? 'skyReset'
#    reactiveValueGetter: -> Session.get('inventoryMerchant') ? 0
#