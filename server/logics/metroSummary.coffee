Meteor.methods
  reCalculateMetroSummary: (id)->
    metro = MetroSummary.findOne(id)
    metro.updateMetroSummary()