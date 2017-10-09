`import Ember from 'ember'`

ConceptsIndexRoute = Ember.Route.extend
  hierarchyService: Ember.inject.service()


  afterModel: (model) ->
    @set 'hierarchyService.target', null
    window.scrollTo(0, 0)

`export default ConceptsIndexRoute`
