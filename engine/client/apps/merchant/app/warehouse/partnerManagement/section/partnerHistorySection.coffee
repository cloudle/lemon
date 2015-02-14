scope = logics.partnerManagement

lemon.defineHyper Template.partnerManagementPartnerHistorySection,
  finalDebtBalance: -> @saleDebt + @importDebt
  oldHistoryPartner: ->
    partnerImportList = Schema.imports.find({partner: @_id, status: 'success'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerSaleList   = Schema.partnerSales.find({partner: @_id, status: 'success'}, {sort: {'version.createdAt': 1}}).fetch()
    if @status is 'myMerchant' then partnerImportList
    else  _.sortBy partnerImportList.concat(partnerSaleList), (item) -> item.version.createdAt

  newHistoryPartner: ->
    partnerImportList = Schema.imports.find({partner: @_id, status: 'unSubmit'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerSaleList   = Schema.partnerSales.find({partner: @_id, status: 'unSubmit'}, {sort: {'version.createdAt': 1}}).fetch()
    _.sortBy partnerImportList.concat(partnerSaleList), (item) -> item.version.createdAt

  rendered: ->
#    @ui.$customImportDebtDate.inputmask("dd/mm/yyyy")
#    @ui.$paidDate.inputmask("dd/mm/yyyy")
#    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
#
#    @ui.$payImportAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandImportAndCustomImport": ->

#


