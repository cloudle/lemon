totalDecoratorTiles = 10
lemon.defineWidget Template.merchantPrintDesigner,
  bodySpaceIterator: ->
    array = []
    array.push i for i in [0...totalDecoratorTiles]
    array