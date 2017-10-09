`import Ember from 'ember'`
`import env from '../config/environment'`
`import clearHierarchyCache from '../utils/clear-hierarchy-cache'`

HierarchyElementComponent = Ember.Component.extend
  hierarchyService: Ember.inject.service('hierarchyService')

  disableEditing: false
  # can be overridden by parent
  saveAfterAdding: true

  # If the popup needs to be shown, set to a record
  # {bad:[concept...], good:[concept...]}
  # so the user can decide whether to keep the good ones or just cancel
  clashResolverPopupData: false

  searchFilter: Ember.computed ->
    toExclude = [env.etms.iscoScheme, env.etms.naceScheme]
    exclude: ["conceptSchemes:" + toExclude.join(',')]

  init: ->
    @_super()
    @get('elements').then (elements) ->
      elements.reload()

  elements: Ember.computed.alias 'concept.narrower'

  actions:
    saveAllElements: (items) ->
      @get("concept.narrower").then (relatedConcept) =>
        items.forEach (item) =>
          relatedConcept.pushObject(item)
        if @get('saveAfterAdding')
          @get('concept').save().then (concept) =>
            promises = []
            promises.push Ember.RSVP.resolve @get('hierarchyService')._clearCache()
            promises.push clearHierarchyCache()
            Ember.RSVP.Promise.all(promises).then =>
              @set('concept.dirty', true)


    transitionToCreate: ->
      @sendAction('transitionToCreate', 'narrower')

`export default HierarchyElementComponent`
