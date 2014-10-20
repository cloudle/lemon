exceptions = ['helpers']

extendObject = (source, destination) ->
  destination[name] = value for name, value of source when !_(exceptions).contains(name)
  destination.prototype[name] = value for name, value of source.prototype

generateSchema = (name) ->
  Schema[name] = new Meteor.Collection name
  Schema[name].helpers(extensionObj.helpers) if extensionObj?.helpers
  Schema[name].attachSchema simpleSchema[name]

generateModel = (name, extensionObj) ->
  singularName = extensionObj.name
  class @[singularName] extends modelBase
  extendObject extensionObj, @[singularName]
  @[singularName].schema = Schema[name]
  @[singularName].prototype.schema = Schema[name]

Schema.add = (name, extensionObj = undefined) ->
  generateSchema(name, extensionObj)
  generateModel(name, extensionObj) if extensionObj

Schema.list = ->
  i = 1
  (console.log "#{i}. #{name}"; i++) for name, value of Schema when value instanceof Mongo.Collection
  return