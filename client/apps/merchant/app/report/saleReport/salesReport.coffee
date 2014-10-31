lemon.defineApp Template.salesReport,
  rendered: ->
    salesData = Schema.sales.find({}).fetch()
    salesGroup = _.groupBy(salesData, (o) -> o.version.createdAt.getMonth())
    dateGroup = _.groupBy(salesGroup["9"], (o) -> o.version.createdAt.getDate())

    yearSources = []; monthSources = []
    columns = [{display: "D.THU", key: "finalPrice"}, {display: "G.GIÁ", key: "discountCash"}]

    for col in columns
      yearColumn = { key: col.display, values: []}
      monthColumn = { key: col.display, values: []}
      yearSources.push yearColumn
      monthSources.push monthColumn

      for month in [1..12]
        if salesGroup[month]
          sum = _.reduce salesGroup[month], (result, sale) ->
            result += sale[col.key]
          , 0

          yearColumn.values.push { x: month, y: sum }
        else
          yearColumn.values.push { x: month, y: 0 }

      for day in [1..30]
        if dateGroup[day]
          sum = _.reduce dateGroup[day], (result, sale) ->
            result += sale[col.key]
          , 0
          monthColumn.values.push {x: day, y: sum}
        else
          monthColumn.values.push {x: day, y: 0}

    yearChart = nv.models.multiBarChart()
    yearChart.xAxis.tickFormat(d3.format(',f'))
    yearChart.yAxis.tickFormat((d)-> accounting.formatNumber(d/1000000) + " tr")
    d3.select('#year-chart svg')
    .datum(yearSources)
    .transition().duration(500)
    .call(yearChart)

    nv.utils.windowResize(yearChart.update)

    monthChart = nv.models.multiBarChart()
    monthChart.xAxis.tickFormat(d3.format(',f'))
    monthChart.yAxis.tickFormat((d)-> accounting.formatNumber(d/1000000) + " tr")
    d3.select('#month-chart svg')
    .datum(monthSources)
    .transition().duration(500)
    .call(monthChart)


