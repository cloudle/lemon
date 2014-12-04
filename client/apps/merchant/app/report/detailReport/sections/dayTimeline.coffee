lemon.defineHyper Template.merchantReportDayTimeline,
  timelineRecords: ->
    transactions = Schema.transactions.find().fetch()
    sales = Schema.sales.find().fetch()
    imports = Schema.imports.find().fetch()
    returns = Schema.returns.find().fetch()

    combined = transactions.concat(sales).concat(imports)
    _.sortBy combined, (item) -> item.version.createdAt
