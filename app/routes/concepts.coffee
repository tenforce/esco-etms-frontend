`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../mixins/ensure-language-set'`

ConceptsRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin,
  userTasks: Ember.inject.service()
  hierarchyService: Ember.inject.service()
  model: (params) ->
    options = {}
    @set 'hierarchyService.taxonomy', params.taxonomy
    @store.findOneQuery('taxonomy', params.taxonomy, options)


`export default ConceptsRoute`
