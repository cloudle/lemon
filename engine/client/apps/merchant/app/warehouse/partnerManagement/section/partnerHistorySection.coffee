scope = logics.partnerManagement

lemon.defineHyper Template.partnerManagementPartnerHistorySection,
  finalDebtBalance: -> @saleDebt + @importDebt
  oldHistoryPartner: -> Schema.imports.find({partner: @_id},{sort: {debtDate: -1}, limit: 2})
  newHistoryPartner: -> []
  rendered: ->
#    @ui.$customImportDebtDate.inputmask("dd/mm/yyyy")
#    @ui.$paidDate.inputmask("dd/mm/yyyy")
#    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
#
#    @ui.$payImportAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandImportAndCustomImport": ->
#      if partner = Session.get("partnerManagementCurrentDistributor")
#        limitExpand = Session.get("mySession").limitExpandImportAndCustomImport ? 5
#        if partner.customImportModeEnabled
#          currentRecords = Schema.customPartner.find({seller: partner._id}).count()
#        else
#          currentRecords = Schema.customPartner.find({seller: partner._id}).count() + Schema.imports.find({partner: partner._id, finish: true, submitted: true}).count()
#        Meteor.subscribe('partnerManagementData', partner._id, currentRecords, limitExpand)
#        Session.set("partnerManagementDataMaxCurrentRecords", currentRecords + limitExpand)
#
#    "click .customImportModeDisable":  (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor")
#        scope.customImportModeDisable(partner._id)
#
##----Create-Custom-Import-----------------------------------------------------------------------------------------------
#    "keydown .new-bill-field": (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor") and event.which is 8 #Backspaces
#        scope.checkAllowCreateCustomImport(template, partner)
#
#    "input .new-bill-field": (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor") #Input
#        scope.checkAllowCreateCustomImport(template, partner)
#
#    "keypress .new-bill-field": (event, template) ->
#      if  Session.get("allowCreateCustomImport") and event.which is 13 #Enter
#        scope.createCustomImport(template)
#
#    "click .createCustomImport":  (event, template) ->
#      if Session.get("allowCreateCustomImport") #Click
#        scope.createCustomImport(template)
#
##-----Create-Transaction-Of-Custom-Import-------------------------------------------------------------------------------
#    "keydown input.new-transaction-custom-import-field": (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor") and event.which is 8
#        scope.checkAllowCreateTransactionOfCustomImport(template, partner)
#
#    "click .createTransactionOfCustomImport": (event, template) ->
#      if Session.get("allowCreateTransactionOfCustomImport")
#        scope.createTransactionOfCustomImport(template)
#
#    "keypress input.new-transaction-custom-import-field": (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor")
#        scope.checkAllowCreateTransactionOfCustomImport(template, partner)
#        if Session.get("allowCreateTransactionOfCustomImport") and event.which is 13
#          scope.createTransactionOfCustomImport(template)
#
##----Create-Transaction-Of-Import-----------------------------------------------------------------------------------------
#    "keydown input.new-transaction-import-field": (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor")
#        scope.checkAllowCreateTransactionOfImport(template, partner) if event.which is 8
#
#    "click .createTransactionOfImport": (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor")
#        if Session.get("allowCreateTransactionOfImport")
#          scope.createTransactionOfImport(template, partner)
#
#    "keypress input.new-transaction-import-field": (event, template) ->
#      if partner = Session.get("partnerManagementCurrentDistributor")
#        scope.checkAllowCreateTransactionOfImport(template, partner)
#        if Session.get("allowCreateTransactionOfImport") and event.which is 13
#          scope.createTransactionOfImport(template, partner)
#


