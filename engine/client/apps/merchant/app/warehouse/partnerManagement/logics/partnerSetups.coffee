Apps.Merchant.partnerManagementInit.push (scope) ->
  scope.createPartner = (template)->
    partner =
      parentMerchant: Session.get('myProfile').parentMerchant
      creator       : Session.get('myProfile').user
      name          : Session.get("partnerManagementSearchFilter")
    existedQuery = {name: partner.name, parentMerchant: partner.parentMerchant}
    if Schema.partners.findOne(existedQuery)
      template.ui.$searchFilter.notify("Đối tác đã tồn tại.", {position: "bottom"})
    else
      Schema.partners.insert  partner, (error, result) ->
        if error then console.log error
        else
          UserSession.set('currentPartnerManagementSelection', result)
#          Meteor.subscribe('partnerManagementData', partnerId)
          MetroSummary.updateMetroSummaryBy(['partner'])
          template.ui.$searchFilter.val(''); Session.set("partnerManagementSearchFilter", "")

#  scope.editPartner = (template) ->
#    partner = Session.get("partnerManagementCurrentPartner")
#    branchPartner = Session.get("partnerManagementBranchPartnerSummary")
#    if partner and branchPartner
#      newName  = template.ui.$partnerName.val()
#      newPrice = template.ui.$partnerPrice.inputmask('unmaskedvalue')
#      newImportPrice = template.ui.$importPrice.inputmask('unmaskedvalue')
#      newPartnerCode = template.ui.$partnerCode.val()
#      return if newName.replace("(", "").replace(")", "").trim().length < 2
#
#      partnerEdit = {$set: {}, $unset: {}}; partnerEdit.$set = splitName(newName)
#      branchPartnerEdit = {$set: {}, $unset: {}}
#
#      if newPrice.length > 0
#        if branchPartner.parentMerchant is branchPartner.merchant and branchPartner.price isnt Number(newPrice)
#          partnerEdit.$set.price = newPrice
#        if branchPartner.price is Number(newPrice) then branchPartnerEdit.$unset.price = ""
#        else branchPartnerEdit.$set.price = newPrice
#      if newImportPrice.length > 0
#        if branchPartner.parentMerchant is branchPartner.merchant and branchPartner.importPrice isnt Number(newImportPrice)
#          partnerEdit.$set.importPrice = newImportPrice
#        if branchPartner.importPrice is Number(newImportPrice) then branchPartnerEdit.$unset.importPrice = ""
#        else branchPartnerEdit.$set.importPrice = newImportPrice
#
#      buildInPartner = Session.get("partnerManagementBuildInPartner")
#      if partner.buildInPartner
#        buildInPartner = if partner.buildInPartner is buildInPartner._id then buildInPartner else Schema.buildInPartners.findOne(partner.buildInPartner)
#        delete partnerEdit.$set.basicUnit; partnerEdit.$unset.basicUnit = ""; partnerEdit.$unset.partnerCode = ""
#        (delete partnerEdit.$set.name; partnerEdit.$unset.name = "") if buildInPartner.name is partnerEdit.$set.name
#      else
#        delete partnerEdit.$set.basicUnit if Schema.partnerUnits.findOne({partner: partner._id})
#        if newPartnerCode.length > 0 and newPartnerCode isnt partner.partnerCode
#          partnerEdit.$set.partnerCode = newPartnerCode
#          barcodeFound = Schema.partners.findOne {partnerCode: newPartnerCode, merchant: partner.merchant}
#        if partnerEdit.$set.name.length > 0
#          if partnerEdit.$set.name is partner.name then delete partnerEdit.$set.name
#          else partnerFound = Schema.partners.findOne {name: partnerEdit.$set.name, merchant: partner.merchant}
#
#
#      if partnerEdit.$set.name and partnerEdit.$set.name.length is 0
#        template.ui.$partnerName.notify("Tên sản phẩn không thể để trống.", {position: "right"})
#      else if partnerFound and partnerFound._id isnt partner._id
#        template.ui.$partnerName.notify("Tên sản phẩm đã tồn tại.", {position: "right"})
#      else if barcodeFound and barcodeFound._id isnt partner._id
#        template.ui.$partnerCode.notify("Mã sản phẩm đã tồn tại.", {position: "right"})
#      else
#        delete partnerEdit.$set if _.keys(partnerEdit.$set).length is 0
#        delete partnerEdit.$unset if _.keys(partnerEdit.$unset).length is 0
#        if _.keys(partnerEdit).length > 0
#          Schema.partners.update partner._id, partnerEdit, (error, result)->
#            if error then console.log error
#
#        delete branchPartnerEdit.$set if _.keys(branchPartnerEdit.$set).length is 0
#        delete branchPartnerEdit.$unset if _.keys(branchPartnerEdit.$unset).length is 0
#        if _.keys(branchPartnerEdit).length > 0
#          Schema.branchPartnerSummaries.update branchPartner._id, branchPartnerEdit, (error, result)->
#            if error then console.log error
#
#        partnerName = (
#          if partner.buildInPartner
#            if partnerEdit.$set?.name then partnerEdit.$set.name else partner.name ? buildInPartner.name
#          else
#            partnerEdit.$set?.name ? partner.name
#        )
#        template.ui.$partnerName.val partnerName
#        Session.set("partnerManagementShowEditCommand", false)
#
#  scope.deletePartner = (partner)->
#    if partner.allowDelete and !partner.buildInPartner
#      Meteor.call 'deleteBranchPartnerSummaryBy', partner._id, (error, result) ->
#        if error then console.log error.error
#        else
#          UserSession.set('currentPartnerManagementSelection', Schema.partners.findOne()?._id ? '')
#          MetroSummary.updateMetroSummaryBy(['partner'])