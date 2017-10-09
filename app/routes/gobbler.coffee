`import Ember from 'ember'`
`import env from '../config/environment'`

GobblerRoute = Ember.Route.extend
  redirect: ->
    @transitionTo('concepts', env.etms.occupationScheme);

`export default GobblerRoute`
