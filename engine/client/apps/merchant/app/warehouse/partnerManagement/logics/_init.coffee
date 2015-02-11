logics.partnerManagement = {}
Apps.Merchant.partnerManagementInit = []
Apps.Merchant.partnerManagementReactive = []

Apps.Merchant.partnerManagementReactive.push (scope) ->
#  merchantId = Session.get("myProfile")?.currentMerchant

  if partnerId  = Session.get("mySession")?.currentPartnerManagementSelection
    Session.set("partnerManagementCurrentPartner", Schema.partners.findOne(partnerId))

##  if partnerId and merchantId
##    partner = Schema.partners.findOne(partnerId)
##    branchPartner = Schema.branchPartnerSummaries.findOne({merchant: merchantId, partner: partnerId})
##    if partner and branchPartner
##      Session.set("partnerManagementBranchPartnerSummary", branchPartner)
##      partner.price       = branchPartner.price if branchPartner.price
##      partner.importPrice = branchPartner.importPrice if branchPartner.importPrice
##
##      partner.salesQuality     = branchPartner.salesQuality
##      partner.totalQuality     = branchPartner.totalQuality
##      partner.availableQuality = branchPartner.availableQuality
##      partner.inStockQuality   = branchPartner.inStockQuality
##      partner.returnQualityByCustomer    = branchPartner.returnQualityByCustomer
##      partner.returnQualityByDistributor = branchPartner.returnQualityByDistributor
##      partner.basicDetailModeEnabled     = branchPartner.basicDetailModeEnabled
##
##      buildInPartner = Schema.buildInPartners.findOne(partner.buildInPartner) if partner.buildInPartner
##      if buildInPartner
##        Session.set("partnerManagementBuildInPartner", buildInPartner)
##        partner.partnerCode = buildInPartner.partnerCode
##        partner.basicUnit = buildInPartner.basicUnit
##
##        partner.name = buildInPartner.name if !partner.name
##        partner.image = buildInPartner.image if !partner.image
##        partner.description = buildInPartner.description if !partner.description
##      Session.set("partnerManagementCurrentPartner", partner)
##
##  if Session.get("partnerManagementUnitEditingRowId")
##    if partnerUnit = Schema.partnerUnits.findOne Session.get("partnerManagementUnitEditingRowId")
##      buildInPartnerUnit = Schema.buildInPartnerUnits.findOne(partnerUnit.buildInPartnerUnit) if partnerUnit.buildInPartnerUnit
##      if buildInPartnerUnit
##        partnerUnit.unit              = buildInPartnerUnit.unit if !partnerUnit.unit
##        partnerUnit.partnerCode       = buildInPartnerUnit.partnerCode if !partnerUnit.partnerCode
##        partnerUnit.conversionQuality = buildInPartnerUnit.conversionQuality if !partnerUnit.conversionQuality
##      Session.set("partnerManagementUnitEditingRow", partnerUnit)
##
##  if Session.get("partnerManagementDetailEditingRowId")
##    Session.set("partnerManagementDetailEditingRow", Schema.partnerDetails.findOne(Session.get("partnerManagementDetailEditingRowId")))
#
#
