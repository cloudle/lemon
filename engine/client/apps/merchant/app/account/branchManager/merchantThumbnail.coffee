lemon.defineWidget Template.merchantThumbnail,
  isntDelete: ->
    if Session.get('myProfile')?.parentMerchant == @_id then false
    else
      metroSummary = Schema.metroSummaries.findOne(merchant: @_id)
      if !metroSummary || (metroSummary.productCount == metroSummary.customerCount == metroSummary.staffCount == 0)
        return true
      else
        return false
  events:
    "click .trash": -> Meteor.call 'destroyBranch', @_id, (error, result) ->
      if error
        console.log error.error
      else
        console.log result