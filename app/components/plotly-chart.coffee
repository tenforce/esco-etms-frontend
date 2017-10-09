`import Ember from 'ember'`

PlotlyChartComponent = Ember.Component.extend
  tagName: 'div'
  classNames:['chart']

  drawn: false

  dataObserver: Ember.observer 'data', ( ->
    ###if @get('drawn') then @redraw()
    else @draw()###
    @draw()
  ).on('didInsertElement')


  draw: ->
    data = @get 'data'
    @set 'lastData', data
    layout = {
      title: @get('title'),
      # height: @get('height'),
      width: @get('width'),
      paper_bgcolor: 'rgba(0,0,0,0)',
      plot_bgcolor: 'rgba(0,0,0,0)',
      showlegend: false,
      legend: {"orientation": "h"}
    }

    annotations = @get 'annotations'
    if annotations
      layout.annotations = annotations
      layout.yaxis = {showticklabels: false}

    element = @$()[0]
    config = {
      displaylogo: false,
      displayModeBar: false,
      scrollZoom: false,
      staticPlot: true
    }
    existing = @get('plot')
    if existing
      Plotly.purge(element)
    plot = Plotly.newPlot(element, data, layout, config);
    @set 'plot', plot
    @set 'drawn', true

  redraw: ->
    console.log "Old : "+JSON.stringify(@get('lastData'))
    console.log "New : "+JSON.stringify(@get('data'))

`export default PlotlyChartComponent`
