class @modelBase
  constructor: (@data) -> @id = @data._id
  @create: (option) -> @schema.insert option
  @findOne: (option) ->
    found = @schema.findOne option
    return new @(found) if found
    return undefined

  @find: (option) ->
    found = @schema.find option
    return new @(found) if found
    return undefined

  @remove: (option) -> @schema.remove option
  @update: (id, option) -> @schema.update(id, option)