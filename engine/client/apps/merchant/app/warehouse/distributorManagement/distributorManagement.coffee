scope = logics.distributorManagement

lemon.defineApp Template.distributorManagement,
  showFilterSearch: -> Session.get("distributorManagementSearchFilter").length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentDistributor: -> Session.get("distributorManagementCurrentDistributor")
  activeClass:-> if Session.get("distributorManagementCurrentDistributor")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("distributorCreationMode")
  unitName: -> if @unit then @unit.unit else @product.basicUnit

#  rendered: -> $(".nano").nanoScroller()
  created: ->
    permission = Role.hasPermission(Session.get("myProfile"), Apps.Merchant.TempPermissions.distributorStaff.key)
    if !permission then Router.go('/merchant')


    lemon.dependencies.resolve('distributorManagement')
    Session.set("distributorManagementSearchFilter", "")

    if Session.get("mySession")
      currentDistributor = Session.get("mySession").currentDistributorManagementSelection
      limitExpand = Session.get("mySession").limitExpandImportAndCustomImport ? 5
      if !currentDistributor
        if distributor = Schema.distributors.findOne()
          UserSession.set("currentCustomerManagementSelection", distributor._id)
          Meteor.subscribe('distributorManagementData', distributor._id, 0, limitExpand)
          Session.set("distributorManagementDataMaxCurrentRecords", limitExpand)
          Session.set("distributorManagementCurrentCustomer", distributor)
      else
        Meteor.subscribe('distributorManagementData', currentDistributor, 0, limitExpand)
        Session.set("distributorManagementDataMaxCurrentRecords", limitExpand)
        Session.set("distributorManagementCurrentCustomer", Schema.distributors.findOne(currentDistributor))

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("distributorManagementSearchFilter", template.ui.$searchFilter.val())
      , "distributorManagementSearchPeople"

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("distributorManagementSearchFilter")?.trim().length > 1 and Session.get("distributorCreationMode")
        scope.createDistributorBySearchFilter(template)

    "click .createDistributorBtn": (event, template) ->
      scope.createDistributorBySearchFilter(template) if Session.get("distributorCreationMode")

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentDistributorManagementSelection: @_id}})
        limitExpand = Session.get("mySession").limitExpandImportAndCustomImport ? 5
        if distributor = Schema.distributors.findOne(@_id)
          countRecords = Schema.customImports.find({seller: distributor._id}).count()
          countRecords += Schema.imports.find({distributor: distributor._id, finish: true, submitted: true}).count() if distributor.customImportModeEnabled is false
          if countRecords is 0
            Meteor.subscribe('distributorManagementData', distributor._id, 0, limitExpand)
            Session.set("distributorManagementDataMaxCurrentRecords", limitExpand)
          else
            Session.set("distributorManagementDataMaxCurrentRecords", limitExpand)
          Session.set("distributorManagementCurrentDistributor", distributor)

        Session.set("allowCreateCustomImport", false)
        Session.set("allowCreateTransactionOfCustomImport", false)

    "click .addReturnDetail": (event, template) ->
      if currentReturn = Session.get('distributorManagementCurrentReturn')
#        if @unit then existedQuery = {product: @product._id, unit: @unit._id} else existedQuery = {product: @product._id}
        existedQuery = {import: currentReturn.import, product: @product._id}
        if productDetail = Schema.productDetails.findOne(existedQuery)
          returnDetail =
            return: currentReturn._id
            import: currentReturn.import
            product: @product._id
            productDetail: productDetail._id
            unitReturnQuality: 1
            unitReturnsPrice: productDetail.importPrice
            conversionQuality: 1
            discountCash: 0
            discountPercent: 0
            price: productDetail.importPrice

          if @unit
            returnDetail.unit = @unit._id
            returnDetail.conversionQuality = @unit.conversionQuality
            returnDetail.unitReturnsPrice = productDetail.importPrice * @unit.conversionQuality

          returnDetail.returnQuality = returnDetail.conversionQuality
          returnDetail.finalPrice = returnDetail.returnQuality * returnDetail.price
          console.log Schema.returnDetails.insert(returnDetail)
          Schema.returns.update currentReturn._id, $inc:{totalPrice: returnDetail.finalPrice, finallyPrice: returnDetail.finalPrice}



#
#    "click .excel-distributor": (event, template) -> $(".excelFileSource").click()
#    "change .excelFileSource": (event, template) ->
#      if event.target.files.length > 0
#        console.log 'importing'
#        $excelSource = $(".excelFileSource")
#        $excelSource.parse
#          config:
#            complete: (results, file) ->
#              console.log file, results
#              Apps.Merchant.importFileDistributorCSV(results.data)
#        $excelSource.val("")