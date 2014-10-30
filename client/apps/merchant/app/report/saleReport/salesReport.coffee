data = ->
  streamLayers(3, 10 + Math.random()*100, .1).map (data, i) ->
    key: 'Steam ' + i
    values: data

streamLayers = (m, n, o) ->
  bump = (a) ->
    x = 1 / (.1 + Math.random())
    y = 2 * Math.random() - .5
    z = 10 / (.1 + Math.random())
    for i in [0...m]
      w = (i / m - y) * z
      a[i] += x * Math.exp(-w * w)
    return

  d3.range(n).map ->
    a = []
    a[i] = o + o * Math.random() for i in [0..m]
    bump(a) for x in [0...5]
    a.map(streamIndex)

streamIndex = (d, i) -> { x: i, y: Math.max(0, d) }

lemon.defineApp Template.salesReport,
  rendered: ->
    myData = data()
    dataSource =
      key: "Doanh Số"
      values: [
        {x: 0, y: 10}
        {x: 1, y: 20}
        {x: 2, y: 30}
      ]
    dataSource = [dataSource]
    chart = nv.models.multiBarChart()
    chart.xAxis.tickFormat(d3.format(',f'))
    chart.yAxis.tickFormat(d3.format(',.1f'))
    d3.select('#my-chart svg')
    .datum(dataSource)
    .transition().duration(500)
    .call(chart)
    nv.utils.windowResize(chart.update)
#    salesData = Schema.orders.find({}).fetch()
#    salesGroup = _.groupBy(salesData, (o) -> o.version.createdAt.getMonth() )


#    for group in salesGroup

#    @testGroupBy = _.chain(data).groupBy("")