scope = logics.partnerManagement

lemon.defineHyper Template.partnerManagementPartnerHistorySection,
  finalDebtBalance: -> @saleDebt + @importDebt
  oldHistoryPartner: ->
    if @merchantType is 'myMerchant'
      Schema.imports.find({partner: @_id},{sort: {debtDate: -1}})
  newHistoryPartner: -> []

  rendered: ->
#    @ui.$customImportDebtDate.inputmask("dd/mm/yyyy")
#    @ui.$paidDate.inputmask("dd/mm/yyyy")
#    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
#
#    @ui.$payImportAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandImportAndCustomImport": ->

#


