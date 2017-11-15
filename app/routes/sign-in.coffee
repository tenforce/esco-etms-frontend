`import Ember from 'ember'`
`import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin'`
`import env from '../config/environment'`

SignInRoute = Ember.Route.extend UnauthenticatedRouteMixin,
  session: Ember.inject.service('session')


`export default SignInRoute`
