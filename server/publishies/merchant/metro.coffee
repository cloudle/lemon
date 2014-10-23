Meteor.publish 'myMetroSummaries', -> Schema.metroSummaries.find {}
Schema.metroSummaries.allow
  insert: -> true
  update: -> true
  remove: -> true