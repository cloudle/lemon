
#formatWarehouseManagerSearch = (item) -> "#{item.name}" if item
#  logics.warehouseManager.merchantSelectOptions:
#    query: (query) -> query.callback
#      results: Session.get("availableMerchant")
#    initSelection: (element, callback) -> callback(Session.get('currentBranch') ? 'skyReset')
#    formatSelection: formatWarehouseManagerSearch
#    formatResult: formatWarehouseManagerSearch
#    placeholder: 'CHỌN SẢN CHI NHÁNH'
#    minimumResultsForSearch: -1
#    changeAction: (e) -> Session.set "currentBranch", _.findWhere(Session.get("availableMerchant"), {_id: e.added._id})
#    reactiveValueGetter: -> Session.get('currentBranch') ? 'skyReset'