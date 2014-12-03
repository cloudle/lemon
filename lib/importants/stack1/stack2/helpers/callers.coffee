Helpers.shortName = (fullName, maxlength = 6) ->
  return undefined if !fullName
  splited = fullName?.split(' ')
  name = splited[splited.length - 1]
  middle = splited[splited.length - 2]?.substring(0,1) if name.length < maxlength
  "#{if middle then middle + '.' else ''} #{name}"

Helpers.respectName = (fullName, gender) -> "#{if gender then 'Anh' else 'Chị'} #{fullName.split(' ').pop()}"
Helpers.firstName = (fullName) -> fullName?.split(' ').pop()
