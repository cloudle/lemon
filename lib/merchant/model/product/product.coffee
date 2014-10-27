Schema.add 'products', class Product
  @insideWarehouse: (warehouseId) -> @schema.find({warehouse: warehouseId})