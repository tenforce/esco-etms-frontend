`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import env from '../config/environment'`

IndexRoute = Ember.Route.extend AuthenticatedRouteMixin,
  session: Ember.inject.service('session')
  afterModel: (transition) ->
    @_super(arguments)
    @transitionTo('concepts', env.etms.occupationScheme)

`export default IndexRoute`
