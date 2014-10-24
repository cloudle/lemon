colors = ['green', 'light-green', 'yellow', 'orange', 'blue', 'dark-blue', 'lime', 'pink', 'red', 'purple', 'dark',
          'gray', 'magenta', 'teal', 'turquoise', 'green-sea', 'emeral', 'nephritis', 'peter-river', 'belize-hole',
          'amethyst', 'wisteria', 'wet-asphalt', 'midnight-blue', 'sun-flower', 'carrot', 'pumpkin', 'alizarin',
          'pomegranate', 'clouds', 'sky', 'silver', 'concrete', 'asbestos']
monoColors = ['green', 'light-green', 'yellow', 'orange', 'blue', 'dark-blue', 'lime', 'pink', 'red', 'purple', 'dark',
              'gray', 'magenta', 'teal', 'turquoise', 'green-sea', 'emeral', 'nephritis', 'peter-river', 'belize-hole',
              'amethyst', 'wisteria', 'wet-asphalt', 'midnight-blue', 'sun-flower', 'carrot', 'pumpkin', 'alizarin',
              'pomegranate', 'clouds', 'sky', 'silver', 'concrete', 'asbestos']

generateRandomIndex = -> Math.floor(Math.random() * monoColors.length)

Helpers.RandomColor = ->
  if colorGenerateHistory.length >= monoColors.length
    colorGenerateHistory = []

  while true
    randomIndex = generateRandomIndex()
    colorExisted = _.contains(colorGenerateHistory, randomIndex)
    console.log colorGenerateHistory
    break unless colorExisted

  colorGenerateHistory.push randomIndex
  monoColors[randomIndex]