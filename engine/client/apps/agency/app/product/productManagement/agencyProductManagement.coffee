scope = logics.agencyProductManagement

lemon.defineApp Template.agencyProductManagement,
  showFilterSearch: -> Session.get("agencyProductManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProduct: -> Session.get("agencyProductManagementCurrentProduct")
  activeClass:-> if Session.get("agencyProductManagementCurrentProduct")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("agencyProductManagementCreationMode")
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    lemon.dependencies.resolve('productManagement')
    Session.set("agencyProductManagementSearchFilter", "")
    if Session.get("mySession")
      currentProduct = Session.get("mySession").currentProductManagementSelection
#      limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
      if !currentProduct
#        if product = Schema.products.findOne()
#          UserSession.set("currentProductManagementSelection", product._id)
#          Meteor.subscribe('agencyProductManagementData', product._id, 0, limitExpand)
#          Session.set("agencyProductManagementDataMaxCurrentRecords", limitExpand)
#          Session.set("agencyProductManagementCurrentProduct", product)
      else
        Meteor.subscribe('productManagementData', currentProduct)
#        Session.set("agencyProductManagementDataMaxCurrentRecords", limitExpand)
        Session.set("agencyProductManagementCurrentProduct", Schema.products.findOne(currentProduct))


  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("agencyProductManagementSearchFilter", template.ui.$searchFilter.val())
      , "agencyProductManagementSearchProduct"

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("agencyProductManagementSearchFilter")?.trim().length > 1
        scope.createProduct(template)
    "click .createProductBtn": (event, template) -> scope.createProduct(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentProductManagementSelection: @_id}})
        Meteor.subscribe('agencyProductManagementData', @_id)

#        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
#        if product = Schema.products.findOne(@_id)
#          countRecords = Schema.customSales.find({buyer: product._id}).count()
#          countRecords += Schema.sales.find({buyer: product._id}).count() if product.customSaleModeEnabled is false
#          if countRecords is 0
#            Meteor.subscribe('agencyProductManagementData', product._id, 0, limitExpand)
#            Session.set("agencyProductManagementDataMaxCurrentRecords", limitExpand)
#          else
#            Session.set("agencyProductManagementDataMaxCurrentRecords", countRecords)
#          Session.set("agencyProductManagementCurrentProduct", product)
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