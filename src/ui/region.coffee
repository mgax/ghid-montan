app.ACTIONBAR_HEIGHT = 30


initialize = (db) ->
  map = {
    db: db
    dispatch: d3.dispatch('ready', 'zoom', 'zoomend', 'redraw')
    debug: {}
  }

  topojson.presimplify(db.topo)
  topojson.presimplify(db.land)
  topojson.presimplify(db.dem)

  canvas = app.canvas(map: map)

  actionbarRight = canvas.actionbar.append('g')

  scaleg = actionbarRight.append('g')
      .attr('class', 'scale')
      .attr('transform', "translate(65.5, 5.5)")

  locationbuttong = actionbarRight.append('g')
      .attr('class', 'locationbutton')
      .attr('transform', "translate(40, #{app.ACTIONBAR_HEIGHT / 2})")

  noteG = actionbarRight.append('g')
      .attr('class', 'note')
      .attr('transform', "translate(10, #{app.ACTIONBAR_HEIGHT / 2})")

  canvas.actionbar
    .append('text')
      .attr('class', 'logo')
      .attr('transform', "translate(#{5},#{app.ACTIONBAR_HEIGHT / 2 + 8})")
    .append('a')
      .attr('xlink:href', '..')
      .text('haihui')

  weatherG = actionbarRight.append('g')
    .attr('transform', 'translate(-30, 0)')

  weatherButton = weatherG.append('a')
    .text("WEATHER")

  placeActionbarRight = ->
    width = parseInt(d3.select('body').style('width'))
    actionbarRight.attr('transform', "translate(#{width - 230},0)")

  placeActionbarRight()
  d3.select(window).on('resize.placeActionbarRight', placeActionbarRight)

  app.location(
    map: map
    locationg: canvas.locationg
    locationbuttong: locationbuttong
  )

  app.dem(
    map: map
    contours: canvas.contours
  )

  app.scale(
    map: map
    scaleg: scaleg
  )

  app.features(
    map: map
    featuresG: canvas.features
    landG: canvas.land
    symbols: canvas.symbols
  )

  app.note(
    map: map
    g: noteG
  )

  app.weather(
    map: map
    button: weatherButton
  )

  d3.select('.splash').remove()
  map.dispatch.ready()
  return map


app.load = (url) ->
  d3.json url, (error, db) ->
    if error then return console.error(error)
    window.map = initialize(db)
