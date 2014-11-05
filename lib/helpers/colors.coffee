colors = ['green', 'light-green', 'yellow', 'orange', 'blue', 'dark-blue', 'lime', 'pink', 'red', 'purple', 'dark',
          'gray', 'magenta', 'teal', 'turquoise', 'green-sea', 'emeral', 'nephritis', 'peter-river', 'belize-hole',
          'amethyst', 'wisteria', 'wet-asphalt', 'midnight-blue', 'sun-flower', 'carrot', 'pumpkin', 'alizarin',
          'pomegranate', 'clouds', 'sky', 'silver', 'concrete', 'asbestos']
monoColors = ['green', 'light-green', 'yellow', 'orange', 'blue', 'dark-blue', 'lime', 'pink', 'red', 'purple', 'dark',
              'gray', 'magenta', 'teal', 'turquoise', 'green-sea', 'emeral', 'nephritis', 'peter-river', 'belize-hole',
              'amethyst', 'wisteria', 'wet-asphalt', 'midnight-blue', 'sun-flower', 'carrot', 'pumpkin', 'alizarin',
              'pomegranate', 'clouds', 'sky', 'silver', 'concrete', 'asbestos']

colorGenerateHistory = []

generateRandomIndex = -> Math.floor(Math.random() * monoColors.length)

Helpers.RandomColor = ->
  if colorGenerateHistory.length >= monoColors.length
    colorGenerateHistory = []

  while true
    randomIndex = generateRandomIndex()
    colorExisted = _.contains(colorGenerateHistory, randomIndex)
    break unless colorExisted

  colorGenerateHistory.push randomIndex
  monoColors[randomIndex]

Helpers.ColorBetween = (r1, g1, b1, r2, g2, b2, percent, disortion = 1) ->
  disortedPercent = percent * disortion
  disortedPercent = 1 if disortedPercent > 1

  deltaR = Math.round(Math.abs(r1 - r2) * disortedPercent)
  deltaG = Math.round(Math.abs(g1 - g2) * disortedPercent)
  deltaB = Math.round(Math.abs(b1 - b2) * disortedPercent)

  multatorR = if r1 < r2 then 1 else -1
  multatorG = if g1 < g2 then 1 else -1
  multatorB = if b1 < b2 then 1 else -1

  return "rgb(#{r1 + deltaR * multatorR}, #{g1 + deltaG * multatorG}, #{b1 + deltaB * multatorB})"