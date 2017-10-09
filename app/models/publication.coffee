`import DS from 'ember-data'`

Publication = DS.Model.extend
  name: DS.attr('string')
  filename: DS.attr('string')
  created: DS.attr('string')
  modified: DS.attr('string')
  issued: DS.attr('string')
  status: DS.attr('string')
  download: DS.attr('string')
  done: Ember.computed 'status' , ->
    @get('status') == 'done'
  running: Ember.computed 'status' , ->
    @get('status') == 'running'
  failed: Ember.computed 'status', ->
    @get('status') == 'failed'
  deletable: Ember.computed 'done', 'failed', ->
    @get('done') || @get('failed')
`export default Publication`
