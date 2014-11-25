Schema.add 'customSales', "CustomSale", class CustomSale
  @newBySale: (order, sale)->

Schema.add 'customSaleDetails', "CustomSaleDetail", class CustomSaleDetail
  @newBySale: (order, sale)->



