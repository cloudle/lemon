simpleSchema.Version = new SimpleSchema
  createdAt:
    type: Date
    autoValue: ->
      if @isInsert
        return new Date
      else if @isUpsert
        return { $setOnInsert: new Date }

      return

  updateAt:
    type: Date
    autoValue: ->
      return new Date() if @isUpdate
      return
    denyInsert: true
    optional: true

simpleSchema.Location = new SimpleSchema
  address:
    type: [String]
    optional: true

  areas:
    type: [String]
    optional: true

simpleSchema.ChildProduct = new SimpleSchema
  product:
    type: String

  quality:
    type: Number

simpleSchema.ChildProductDetail = new SimpleSchema
  detail:
    type: String
    optional: true

  returnQuality:
    type: Number
    optional: true