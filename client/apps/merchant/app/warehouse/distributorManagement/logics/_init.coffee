logics.distributorManagement = {}
Apps.Merchant.distributorManagementInit = []
Apps.Merchant.distributorManagementReactive = []

Apps.Merchant.distributorManagementReactive.push (scope) ->
  if Session.get('allowCreateDistributor') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreateDistributor = allowCreate

  if distributorId = Session.get("mySession")?.currentDistributorManagementSelection
    Session.set("distributorManagementCurrentDistributor", Schema.distributors.findOne(distributorId))

    if latestCustomImport = Schema.customImports.findOne({seller: distributorId}, {sort: {debtDate: -1}})
      if latestTransaction = Schema.transactions.findOne({latestImport: latestCustomImport._id}, {sort: {debtDate: -1}})
        $("[name=paidDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
      else
        $("[name=paidDate]").val(moment(latestCustomImport.debtDate).format('DDMMYYY'))
    else
      $("[name=paidDate]").val('')

    if latestImport = Schema.imports.findOne({distributor: distributorId}, {sort: {'version.createdAt': -1}})
      if latestTransaction = Schema.transactions.findOne({latestImport: latestImport._id}, {sort: {debtDate: -1}})
        $("[name=paidSaleDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
      else
        $("[name=paidSaleDate]").val(moment(latestImport.version.createdAt).format('DDMMYYY'))
    else
      $("[name=paidSaleDate]").val('')

#  if Session.get("distributorManagementCurrentDistributor")
#    Meteor.subscribe('distributorManagementData', Session.get("distributorManagementCurrentDistributor")._id)
