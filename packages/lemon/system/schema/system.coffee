simpleSchema.systems = new SimpleSchema
  version:
    type: String

  updateAt:
    type: Date
    autoValue: ->
      return new Date()
      return