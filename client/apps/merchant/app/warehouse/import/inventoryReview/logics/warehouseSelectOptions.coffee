#formatWarehouseSearch = (item) -> "#{item.name}" if item
#  warehouseSelectOptions:
#    query: (query) -> query.callback
#      results: _.filter Session.get('allWarehouseInventory'), (item) ->
#        unsignedTerm = Sky.helpers.removeVnSigns query.term
#        unsignedName = Sky.helpers.removeVnSigns item.name
#        unsignedName.indexOf(unsignedTerm) > -1
#    initSelection: (element, callback) -> callback(Session.get('inventoryWarehouse') ? 'skyReset')
#    formatSelection: formatWarehouseSearch
#    formatResult: formatWarehouseSearch
#    placeholder: 'CHỌN CHI NHÁNH'
#    minimumResultsForSearch: -1
#    changeAction: (e) ->
#      Schema.userProfiles.update Session.get('currentProfile')._id, $set:
#        inventoryWarehouse: e.added._id
#    reactiveValueGetter: -> Session.get('inventoryWarehouse') ? 'skyReset'