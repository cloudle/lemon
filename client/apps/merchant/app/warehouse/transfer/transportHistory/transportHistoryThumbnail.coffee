lemon.defineWidget Template.transportHistoryThumbnail,
  colorClass: ->
    if @submit == false and @success == false then return 'lime'
    if @submit == true and @success == false then return 'orange'
    if @submit == true and @success == true then return 'belize-hole'

  status: ->
    if @submit == false and @success == false then return 'Checking'
    if @submit == true and @success == false then return 'Fail'
    if @submit == true and @success == true then return 'Success'

  creatorName: (id) -> (Schema.userProfiles.findOne({user: id}))?.fullName
  createDate: -> moment(@version.updateAt).format("DD/MM/YYYY")

  events:
    'click .full-desc.trash': -> UserSession.get('currentInventoryHistory', @_id)
