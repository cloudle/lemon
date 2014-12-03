scope = logics.stockManagement

lemon.defineApp Template.stockManagement,
  showFilterSearch: -> Session.get("stockManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProduct: -> Session.get("stockManagementCurrentProduct")
  activeClass:-> if Session.get("stockManagementCurrentProduct")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("stockManagementCreationMode")
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    Session.set("stockManagementSearchFilter", "")
#    if Session.get("mySession")
#      console.log Session.get("mySession")
#      currentStock = Session.get("mySession").currentStockManagementSelection
#      limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
#      if !currentStock
#        if stock = Schema.stocks.findOne()
#          UserSession.set("currentStockManagementSelection", stock._id)
#          Meteor.subscribe('stockManagementData', stock._id, 0, limitExpand)
#          Session.set("stockManagementDataMaxCurrentRecords", limitExpand)
#          Session.set("stockManagementCurrentStock", stock)
#      else
#        Meteor.subscribe('stockManagementData', currentStock, 0, limitExpand)
#        Session.set("stockManagementDataMaxCurrentRecords", limitExpand)
#        Session.set("stockManagementCurrentStock", Schema.stocks.findOne(currentStock))


  events:
    "input .search-filter": (event, template) ->
      Session.set("stockManagementSearchFilter", template.ui.$searchFilter.val())
#    "keypress input[name='searchFilter']": (event, template)->
#      if event.which is 13 and Session.get("stockManagementSearchFilter")?.trim().length > 1
#        scope.createStock(template)
#    "click .createStockBtn": (event, template) -> scope.createStock(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentProductManagementSelection: @_id}})
        Meteor.subscribe('stockManagementData', @_id)

#        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
#        if stock = Schema.stocks.findOne(@_id)
#          countRecords = Schema.customSales.find({buyer: stock._id}).count()
#          countRecords += Schema.sales.find({buyer: stock._id}).count() if stock.customSaleModeEnabled is false
#          if countRecords is 0
#            Meteor.subscribe('stockManagementData', stock._id, 0, limitExpand)
#            Session.set("stockManagementDataMaxCurrentRecords", limitExpand)
#          else
#            Session.set("stockManagementDataMaxCurrentRecords", countRecords)
#          Session.set("stockManagementCurrentStock", stock)
#
#        Session.set("allowCreateCustomSale", false)
#        Session.set("allowCreateTransactionOfCustomSale", false)

#    "click .excel-stock": (event, template) -> $(".excelFileSource").click()
#    "change .excelFileSource": (event, template) ->
#      if event.target.files.length > 0
#        console.log 'importing'
#        $excelSource = $(".excelFileSource")
#        $excelSource.parse
#          config:
#            complete: (results, file) ->
#              console.log file, results
#              Apps.Merchant.importFileStockCSV(results.data)
#        $excelSource.val("")