`import Ember from 'ember'`

UserRightsMixin = Ember.Mixin.create
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  userIsTranslator: Ember.computed.alias 'currentUser.userIsTranslator'
  userIsReviewer: Ember.computed.alias 'currentUser.userIsReviewer'
  userIsAdmin: Ember.computed.alias 'currentUser.userIsAdmin'

`export default UserRightsMixin`
