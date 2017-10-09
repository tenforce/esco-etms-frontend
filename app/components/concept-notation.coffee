`import Ember from 'ember'`

ConceptNotationComponent = Ember.Component.extend
  tagName: ''
  init: ->
    this._super()

  shouldDisplay: Ember.computed 'model.defaultCode', ->
    if @get('model.defaultCode') then return true
    else return false

`export default ConceptNotationComponent`
