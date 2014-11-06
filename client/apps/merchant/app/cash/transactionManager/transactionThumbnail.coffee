lemon.defineWidget Template.transactionThumbnail,
  colorClass: -> if @status is 'closed' then 'lime' else 'pumpkin'
  avatarUrl: ->
    owner = Schema.customers.findOne(@owner)
    return undefined if !owner
    AvatarImages.findOne(owner.avatar)?.url()

  ownerName: -> Schema.customers.findOne(@owner)?.name
  formatNumber: (number) -> accounting.formatMoney(number, { format: "%v", precision: 0 })
  daysFromNow: -> (new Date) - @dueDay if @dueDay
  meterStyle: ->
    percentage = @debitCash / @totalCash
    return {
      percent: percentage * 100
      color: Helpers.ColorBetween(135, 196, 57, 255, 0, 0, percentage, 0.9)
    }