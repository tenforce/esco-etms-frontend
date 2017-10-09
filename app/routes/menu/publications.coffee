`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`

PublicationsRoute = Ember.Route.extend AuthenticatedRouteMixin,
  model: (params) ->
    @store.findAll('publication')


`export default PublicationsRoute`
