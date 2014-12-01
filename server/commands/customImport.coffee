Meteor.methods
  createNewCustomImport: (customImport)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      latestCustomImport = Schema.customImports.findOne({seller: customImport.seller}, {sort: {debtDate: -1}})
      distributor = Schema.distributors.findOne({_id: customImport.seller, parentMerchant: profile.parentMerchant})
      if distributor.customImportModeEnabled is true
        if latestCustomImport
          if customImport.debtDate >= latestCustomImport.debtDate
            if Schema.customImports.insert customImport
              latestCustomImportDetails = Schema.customImportDetails.find({customImport: latestCustomImport._id})
              if latestCustomImportDetails.count() > 0
                for customImportDetail in latestCustomImportDetails.fetch()
                  Schema.customImportDetails.update customImportDetail._id, $set:{allowDelete: false}
                Schema.customImports.update latestCustomImport._id, $set:{allowDelete: false}

              latestTransactions = Schema.transactions.find({owner: distributor._id, allowDelete: true}).fetch()
              (Schema.transactions.update transaction._id, $set:{allowDelete: false}) for transaction in latestTransactions
        else
          Schema.customImports.insert customImport

  deleteCustomImport: (customImportId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customImport = Schema.customImports.findOne({_id: customImportId, parentMerchant: profile.parentMerchant})
        distributor = Schema.distributors.findOne({_id: customImport.buyer, parentMerchant: profile.parentMerchant})
        if distributor.customImportModeEnabled is true
          latestCustomImport  = Schema.customImports.findOne({buyer: customImport.buyer}, {sort: {debtDate: -1}})
          customImportDetails = Schema.customImportDetails.find({customImport: customImport._id}).fetch()

          if customImport._id is latestCustomImport._id
            if customImportDetails.length > 0
              incCustomerOption = {
                customImportDebt     : -customImport.debtBalanceChange
                customImportTotalCash: -customImport.debtBalanceChange
              }
              Schema.distributors.update distributor._id, $inc: incCustomerOption
              Schema.customImportDetails.remove customImportDetail._id for customImportDetail in customImportDetails
            Schema.customImports.remove customImport._id

            transactions = Schema.transactions.find({latestImport: customImport._id}).fetch()
            if transactions.length > 0
              incCustomerOption = {customImportDebt: 0, customImportPaid: 0}
              for transaction in transactions
                incCustomerOption.customImportDebt += transaction.debtBalanceChange
                incCustomerOption.customImportPaid -= transaction.debtBalanceChange
                Schema.transactions.remove transaction._id
              Schema.distributors.update distributor._id, $inc: incCustomerOption
          else
            Schema.customImports.remove customImport._id if customImportDetails.length is 0

          if latestCustomImport = Schema.customImports.findOne({buyer: customImport.buyer}, {sort: {debtDate: -1}})
            for customImportDetail in Schema.customImportDetails.find({customImport: latestCustomImport._id}).fetch()
              Schema.customImportDetails.update customImportDetail._id, $set:{allowDelete: true}

            if latestTransaction = Schema.transactions.findOne({latestImport: latestCustomImport._id}, {sort: {debtDate: -1}})
              Schema.transactions.update latestTransaction._id, $set:{allowDelete: true}
            else
              Schema.customImports.update latestCustomImport._id, $set:{allowDelete: true}

  updateCustomImportByCreateCustomImportDetail: (customImportDetail)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      customImport = Schema.customImports.findOne({_id: customImportDetail.customImport, parentMerchant: profile.parentMerchant})
      latestCustomImport = Schema.customImports.findOne({buyer: customImport.buyer}, {sort: {debtDate: -1}})
      if customImport._id is latestCustomImport._id
        distributor = Schema.distributors.findOne({_id: customImport.buyer, parentMerchant: profile.parentMerchant})
        if distributor.customImportModeEnabled is true
          if Schema.customImportDetails.insert customImportDetail
            incCustomImportOption = {
              totalCash        : customImportDetail.finalPrice
              debtBalanceChange: customImportDetail.finalPrice
              latestDebtBalance: customImportDetail.finalPrice
            }
            Schema.customImports.update customImportDetail.customImport, $inc: incCustomImportOption

            distributor = Schema.distributors.findOne({_id: customImport.buyer, parentMerchant: profile.parentMerchant})
            incCustomerOption = {
              customImportDebt     : customImportDetail.finalPrice
              customImportTotalCash: customImportDetail.finalPrice
            }
            Schema.distributors.update distributor._id, $inc: incCustomerOption

            beforeDebtBalance = Schema.customImports.findOne(customImport._id).latestDebtBalance
            for transaction in Schema.transactions.find({latestImport: customImport._id}).fetch()
              latestDebtBalance = beforeDebtBalance - transaction.debtBalanceChange
              Schema.transactions.update transaction._id, $set: {beforeDebtBalance: beforeDebtBalance, latestDebtBalance: latestDebtBalance}
              beforeDebtBalance = latestDebtBalance

  updateCustomImportByDeleteCustomImportDetail: (customImportDetailId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      if customImportDetail = Schema.customImportDetails.findOne({_id: customImportDetailId, parentMerchant: profile.parentMerchant})
        customImport = Schema.customImports.findOne({_id: customImportDetail.customImport, parentMerchant: profile.parentMerchant})
        latestCustomImport = Schema.customImports.findOne({buyer: customImport.buyer}, {sort: {debtDate: -1}})
        if customImport._id is latestCustomImport._id
          distributor = Schema.distributors.findOne({_id: customImport.buyer, parentMerchant: profile.parentMerchant})
          if distributor.customImportModeEnabled is true
            Schema.customImportDetails.remove customImportDetail._id

            setOption = {}
            setOption = {allowDelete: true} if Schema.customImportDetails.findOne({customImport: customImport._id}) is undefined
            incCustomImportOption = {
              totalCash        : -customImportDetail.finalPrice
              debtBalanceChange: -customImportDetail.finalPrice
              latestDebtBalance: -customImportDetail.finalPrice
            }
            Schema.customImports.update customImportDetail.customImport, $set: setOption, $inc: incCustomImportOption

            distributor = Schema.distributors.findOne({_id: customImport.buyer, parentMerchant: profile.parentMerchant})
            incCustomerOption = {
              customImportDebt     : -customImportDetail.finalPrice
              customImportTotalCash: -customImportDetail.finalPrice
            }
            Schema.distributors.update distributor._id, $inc: incCustomerOption

            beforeDebtBalance = Schema.customImports.findOne(customImport._id).latestDebtBalance
            for transaction in Schema.transactions.find({latestImport: customImport._id}).fetch()
              latestDebtBalance = beforeDebtBalance - transaction.debtBalanceChange
              Schema.transactions.update transaction._id, $set: {beforeDebtBalance: beforeDebtBalance, latestDebtBalance: latestDebtBalance}
              beforeDebtBalance = latestDebtBalance
