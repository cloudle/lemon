lemon.defineWidget Template.warehouseThumbnail,
  isntDelete: -> if !Schema.products.findOne({warehouse: @_id}) and @isRoot == false then true
  events:
    "click .trash": ->
      warehouse = Schema.warehouses.findOne({_id: @_id, isRoot: false})
      if warehouse
        product = Schema.products.findOne({warehouse: warehouse._id})
        unless product
          Schema.warehouses.remove warehouse._id
          MetroSummary. updateMetroSummaryBy(['warehouse'])