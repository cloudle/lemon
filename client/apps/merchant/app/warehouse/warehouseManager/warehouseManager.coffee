lemon.defineApp Template.warehouseManager,
  events:
    "input input": (event, template) -> logics.warehouseManager.checkAllowCreate(template)
    "click #createWarehouse": (event, template) -> logics.warehouseManager.createWarehouse(template)

