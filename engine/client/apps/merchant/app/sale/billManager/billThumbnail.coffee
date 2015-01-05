lemon.defineWidget Template.billThumbnail,
  isntDelete: ->
    if @status == true and @received == false then true else false
  buyerName: -> Schema.customers.findOne(@buyer)?.name
  sellerName: -> Schema.userProfiles.findOne(@seller)?.fullName
  avatarUrl: ->
    buyer = Schema.customers.findOne(@buyer)
    return undefined if !buyer
    AvatarImages.findOne(buyer.avatar)?.url()
  events:
    "dblclick .full-desc.trash": ->