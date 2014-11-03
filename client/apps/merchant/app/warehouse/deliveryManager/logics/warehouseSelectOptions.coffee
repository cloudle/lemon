
#formatWarehouseSearch = (item) -> "#{item.name}" if item
#  warehouseSelectOptions:
#    query: (query) -> query.callback
#      results: _.filter Session.get('availableDeliveryWarehouses'), (item) ->
#        unsignedTerm = Sky.helpers.removeVnSigns query.term
#        unsignedName = Sky.helpers.removeVnSigns item.name
#        unsignedName.indexOf(unsignedTerm) > -1
#    initSelection: (element, callback) -> callback(Session.get('currentDeliveryWarehouse'))
#    formatSelection: formatWarehouseSearch
#    formatResult: formatWarehouseSearch
#    placeholder: 'CHỌN CHI NHÁNH'
#    changeAction: (e) ->
#      Schema.userProfiles.update Session.get('currentProfile')._id, $set:
#        currentDeliveryWarehouse: e.added._id
#        currentDeliveryFilter   : 0
#    reactiveValueGetter: -> Session.get('currentDeliveryWarehouse')

