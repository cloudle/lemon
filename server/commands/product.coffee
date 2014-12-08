#Meteor.methods
#  insertProductAndRandomBarcode: (existedQuery, product)->
#    barcode = (Math.floor(Math.random() * 100000000000) + 89 *100000000000).toString()
#    existedQuery.productCode = barcode
#    Schema.products.findOne existedQuery