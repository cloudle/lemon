Helpers.FormatDate = (format = 0, dateObj = new Date())->
  curr_Day   = dateObj.getDate()
  curr_Month = dateObj.getMonth()+1
  curr_Tear  = dateObj.getFullYear().toString()
  if curr_Day < 10 then curr_Day = "0#{curr_Day}"
  if curr_Month < 10 then curr_Month = "0#{curr_Month}"
  switch format
    when 0 then "#{curr_Day}#{curr_Month}#{curr_Tear.substring(2,4)}"
    when 1 then "#{curr_Day}-#{curr_Month}-#{curr_Tear}"