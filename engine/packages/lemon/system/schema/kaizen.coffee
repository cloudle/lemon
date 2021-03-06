simpleSchema.kaizens = new SimpleSchema
  creator:
    type: String

  owner:
    type: String
    optional: true

  group:
    type: String
    optional: true

  description:
    type: String

  priority:
    type: Number

  totalDuration:
    type: Number
    optional: true

  remake:
    type: Number

  duration:
    type: Number

  selectDate:
    type: Date
    optional: true

  starDate:
    type: Date
    optional: true

  finishDate:
    type: Date
    optional: true

  lateDuration:
    type: Boolean

  deleted:
    type: Boolean

  status:
    type: String

  version: { type: simpleSchema.Version }

