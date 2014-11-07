lemon.defineWidget Template.importReviewThumbnail,
  creatorName: (id) -> (Schema.userProfiles.findOne({user: id}))?.fullName
  createDate: (date) -> moment(date).format("DD/MM/YYYY")

  events:
    'click .full-desc.trash': -> UserSession.get('currentInventoryHistory', @_id)
