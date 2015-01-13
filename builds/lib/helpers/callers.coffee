Helpers.shortName = (fullName, maxlength = 6) ->
  return undefined if !fullName
  splited = fullName?.split(' ')
  name = splited[splited.length - 1]
  middle = splited[splited.length - 2]?.substring(0,1) if name.length < maxlength
  "#{if middle then middle + '.' else ''} #{name}"

Helpers.shortName2 = (fullName, word = 2) ->
  return undefined if !fullName
  splited = fullName?.split(' ')
  name = ""
  if word < 1 then word = 1
  if splited.length > word
    for i in [word..1]
      name += "#{splited[splited.length-i]}#{if i > 1 then ' ' else ''}"
    name
  else
    fullName

Helpers.respectName = (fullName, gender) -> "#{if gender then 'Anh' else 'Chị'} #{fullName.split(' ').pop()}"
Helpers.firstName = (fullName) -> fullName?.split(' ').pop()

