`import Ember from 'ember'`
`import clearHierarchyCache from '../utils/clear-hierarchy-cache'`

HierarchyElementComponent = Ember.Component.extend
  hierarchyService: Ember.inject.service('hierarchyService')

  init: ->
    @_super()
    @get('elements').then (elements) ->
      elements.reload()

  elements: Ember.computed.alias 'concept.broader'

  disableEditing: false
  # can be overridden by parent
  saveAfterAdding: true

  showDeleteButton: Ember.computed 'disableEditing', 'elements', 'elements.length', ->
    @get('elements')?.then (elements) =>
      disableEditing = @get 'disableEditing'
      if disableEditing then return false
      else return elements.get('length') > 1
  actions:
    saveAllElements: (items) ->
      @get("concept.broader").then (relatedConcept) =>
        items.forEach (item) =>
          relatedConcept.pushObject(item)
        if @get('saveAfterAdding')
          @get('concept').save().then (concept) =>
            promises = []
            promises.push Ember.RSVP.resolve @get('hierarchyService')._clearCache()
            promises.push clearHierarchyCache()
            Ember.RSVP.Promise.all(promises).then =>
              items.forEach (broader) =>
                broader.set('dirty', true)
    deleteRelation: (item) ->
      concept = @get('concept')
      concept?.get('broader').then (broaders) =>
        broaders.removeObject(item)
        if @get('saveAfterAdding')
          concept.save().then =>
            promises = []
            promises.push Ember.RSVP.resolve @get('hierarchyService')._clearCache()
            promises.push clearHierarchyCache()
            Ember.RSVP.Promise.all(promises).then =>
              item.set('dirty', true)


    transitionToCreate: ->
      @sendAction('transitionToCreate', 'broader')

`export default HierarchyElementComponent`
