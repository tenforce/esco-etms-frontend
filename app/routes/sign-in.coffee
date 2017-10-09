`import Ember from 'ember'`
`import UnauthenticatedRouteMixin from 'ember-simple-auth/mixins/unauthenticated-route-mixin'`
`import env from '../config/environment'`

SignInRoute = Ember.Route.extend UnauthenticatedRouteMixin,
  session: Ember.inject.service('session')

  model: ->
    @get('session').authenticate('authenticator:ecas').then( =>
      @transitionTo('concepts', env.etms.occupationScheme)
    )

`export default SignInRoute`
