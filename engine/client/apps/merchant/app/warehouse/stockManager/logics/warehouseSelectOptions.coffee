#formatWarehouseSearch = (item) -> "#{item.name}" if item
#  warehouseSelectOptions:
#    query: (query) -> query.callback
#      results: _.filter Session.get('availableWarehouses'), (item) ->
#        unsignedTerm = Sky.helpers.removeVnSigns query.term
#        unsignedName = Sky.helpers.removeVnSigns item.name
#        unsignedName.indexOf(unsignedTerm) > -1
#    initSelection: (element, callback) -> callback(Session.get('currentStockWarehouse') ? 'skyReset')
#    formatSelection: formatWarehouseSearch
#    formatResult: formatWarehouseSearch
#    placeholder: 'CHỌN CHI NHÁNH'
#    minimumResultsForSearch: -1
#    changeAction: (e) -> Session.set 'currentStockWarehouse', Schema.warehouses.findOne(e.added._id)
#    reactiveValueGetter: -> Session.get('currentStockWarehouse') ? 'skyReset'

