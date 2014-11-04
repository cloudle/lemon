lemon.defineWidget Template.billThumbnail,
  isntDelete: ->
    if @status == true and @received == false then true else false
  buyerName: -> Schema.customers.findOne(@buyer)?.name
  sellerName: -> Schema.userProfiles.findOne(@seller)?.fullName
  events:
    "dblclick .full-desc.trash": ->