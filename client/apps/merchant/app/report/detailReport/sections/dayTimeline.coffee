lemon.defineHyper Template.merchantReportDayTimeline,
  created: -> Session.setDefault('totalRevenue', 0)

  timelineMeta: ->
    meta = {}

    profile = Schema.userProfiles.findOne({user: @creator})
    if profile?.fullName
      meta.creatorFullName = profile.fullName ? '?'
      meta.creatorFirstName = Helpers.firstName(meta.creatorFullName)
    else
      meta.creatorFullName = meta.creatorFirstName = Meteor.users.findOne(@creator)?.emails[0].address

    meta.creatorAvatar = AvatarImages.findOne(profile.avatar)?.url() if profile.avatar

    if @timelineType is 'transaction'
      meta.icon = 'icon-money'
      meta.color = if @receivable then 'lime' else 'pumpkin'
      action = if @receivable then 'thu tiền' else 'chi tiền'
      optionalDesc = if @description then "(#{@description})" else ''
      meta.message = "#{meta.creatorFullName} #{action} #{optionalDesc}, giá trị #{@debtBalanceChange}. <br/>
                     Cân bằng nợ mới nhất từ #{accounting.formatNumber(@beforeDebtBalance)} thành
                     #{accounting.formatNumber(@latestDebtBalance)}."

    else if @timelineType is 'sale'
      meta.icon = 'icon-tag'
      meta.color = 'blue'
      meta.action = 'bán hàng'
      buyerName = Schema.customers.findOne(@buyer)?.name
      meta.message = "#{meta.creatorFullName} bán hàng cho #{buyerName}, giá trị #{@debtBalanceChange}. <br/>
                     Cân bằng nợ mới nhất từ #{accounting.formatNumber(@beforeDebtBalance)} thành
                     #{accounting.formatNumber(@latestDebtBalance)}."

    else if @timelineType is 'return'
      meta.icon = 'icon-reply-outline'
      meta.color = 'pumpkin'
      meta.message = "#{meta.creatorFullName} thực hiện trả hàng với tổng giá trị #{accounting.formatNumber(@finallyPrice)}."
    else if @timelineType is 'import'
      meta.icon = 'icon-download-outline'
      meta.color = 'amethyst'
      meta.message = "#{meta.creatorFullName} nhập kho với tổng giá trị #{accounting.formatNumber(@debtBalanceChange)}."

    return meta

  timeHook: -> moment(@version.createdAt).format 'hh:mm'

  timelineRecords: ->
    totalRevenue = 0
    transactions = Schema.transactions.find().fetch()
    sales = Schema.sales.find().fetch()
    imports = Schema.imports.find().fetch()
    returns = Schema.returns.find().fetch()

    combined = transactions.concat(sales).concat(imports)
    sorted = _.sortBy combined, (item) ->
      if item.group
        item.timelineType = 'transaction'
        totalRevenue += item.debtBalanceChange
        item.merchantRevenueDay = totalRevenue
      else if item.orderCode
        item.timelineType = 'sale'
        totalRevenue += item.debtBalanceChange
        item.merchantRevenueDay = totalRevenue
      else if item.returnCode
        item.timelineType = 'return'
        totalRevenue += item.finallyPrice
        item.merchantRevenueDay = totalRevenue
      else
        item.timelineType = 'import'
        totalRevenue += item.debtBalanceChange
        item.merchantRevenueDay = totalRevenue

      item.version.createdAt
    console.log sorted
    console.log totalRevenue
    sorted

