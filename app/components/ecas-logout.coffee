`import Ember from 'ember'`

EcasLogoutComponent = Ember.Component.extend
  session: Ember.inject.service('session')
  actions:
    logout: ->
      @get('session').invalidate('authenticator:mu-semtech')

`export default EcasLogoutComponent`
