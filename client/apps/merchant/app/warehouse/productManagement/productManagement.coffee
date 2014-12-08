scope = logics.productManagement

lemon.defineApp Template.productManagement,
  showFilterSearch: -> Session.get("productManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProduct: -> Session.get("productManagementCurrentProduct")
  activeClass:-> if Session.get("productManagementCurrentProduct")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("productManagementCreationMode")
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    Session.set("productManagementSearchFilter", "")
    if Session.get("mySession")
      currentProduct = Session.get("mySession").currentProductManagementSelection
#      limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
      if !currentProduct
#        if product = Schema.products.findOne()
#          UserSession.set("currentProductManagementSelection", product._id)
#          Meteor.subscribe('productManagementData', product._id, 0, limitExpand)
#          Session.set("productManagementDataMaxCurrentRecords", limitExpand)
#          Session.set("productManagementCurrentProduct", product)
      else
        Meteor.subscribe('productManagementData', currentProduct)
#        Session.set("productManagementDataMaxCurrentRecords", limitExpand)
        Session.set("productManagementCurrentProduct", Schema.products.findOne(currentProduct))


  events:
    "input .search-filter": (event, template) ->
      Session.set("productManagementSearchFilter", template.ui.$searchFilter.val())
    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("productManagementSearchFilter")?.trim().length > 1
        scope.createProduct(template)
    "click .createProductBtn": (event, template) -> scope.createProduct(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentProductManagementSelection: @_id}})
        Meteor.subscribe('productManagementData', @_id)

#        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
#        if product = Schema.products.findOne(@_id)
#          countRecords = Schema.customSales.find({buyer: product._id}).count()
#          countRecords += Schema.sales.find({buyer: product._id}).count() if product.customSaleModeEnabled is false
#          if countRecords is 0
#            Meteor.subscribe('productManagementData', product._id, 0, limitExpand)
#            Session.set("productManagementDataMaxCurrentRecords", limitExpand)
#          else
#            Session.set("productManagementDataMaxCurrentRecords", countRecords)
#          Session.set("productManagementCurrentProduct", product)
#
#        Session.set("allowCreateCustomSale", false)
#        Session.set("allowCreateTransactionOfCustomSale", false)

#    "click .excel-product": (event, template) -> $(".excelFileSource").click()
#    "change .excelFileSource": (event, template) ->
#      if event.target.files.length > 0
#        console.log 'importing'
#        $excelSource = $(".excelFileSource")
#        $excelSource.parse
#          config:
#            complete: (results, file) ->
#              console.log file, results
#              Apps.Merchant.importFileProductCSV(results.data)
#        $excelSource.val("")