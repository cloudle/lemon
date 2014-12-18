Meteor.methods
  updateDistributorDebitAndSale: ->
    for distributor in Schema.distributors.find({}).fetch()
      setOption = {totalSales: 0,  totalDebit: 0}
      Schema.distributors.update distributor._id, $set: setOption

    for transaction in Schema.transactions.find({group: {$in:['import', 'distributor']} , receivable: false}).fetch()
      setOption = {allowDelete: false}
      incOption = {totalSales: transaction.totalCash,  totalDebit: transaction.debitCash}
      Schema.distributors.update transaction.owner, $set: setOption, $inc: incOption

  calculateDistributor: (id)->
    if distributor = Schema.distributors.findOne(id)
      distributorOption =
        customImportPaid : 0
        customImportLoan : 0
        customImportDebt : 0
        customImportTotalCash : 0
#        importPaid      : 0
#        importDebt      : 0
#        importTotalCash : 0

      Schema.customImports.find({seller: distributor._id}).forEach(
        (customImport)->
          distributorOption.customImportTotalCash += customImport.debtBalanceChange
          distributorOption.customImportDebt += customImport.debtBalanceChange
      )

#      Schema.transactions.find({owner: distributor._id}).forEach(
#        (transaction)->
#          distributorOption.customImportPaid += transaction.debtBalanceChange
#          distributorOption.customImportDebt -= transaction.debtBalanceChange
#      )
      console.log distributorOption

      Schema.distributors.update distributor._id, $set: distributorOption




  distributorToImport : (distributor, profile)->
    try
      throw 'Chưa đăng nhập.' if !userId = Meteor.userId()
      profile = Schema.userProfiles.findOne({user: userId}) if !profile || profile.user != userId
      if distributor.parentMerchant != profile.parentMerchant
        distributor = Schema.distributors.findOne({_id: distributor._id ,parentMerchant: profile.parentMerchant})

      if distributor
        importFound = Schema.imports.findOne({
          creator: userId
          distributor: distributor._id
          merchant: profile.currentMerchant
          finish: false
        }, {sort: {'version.createdAt': -1}})
        if !importFound then importFound = Import.createdNewBy(null, distributor._id, profile)
        Schema.userSessions.update {user: userId}, {$set:{'currentImport': importFound._id}}

      else throw 'Không tìm thấy nhà cung cấp'
        #wRsWpe5F6ydP6wzjw

    catch error
      throw new Meteor.Error('distributorToImport', error)
