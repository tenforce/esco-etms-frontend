`import Ember from 'ember'`

# will check if user.language is set, if not will try to retrieve it and if that fails redirect to a page to set it
EnsureLanguageSetMixin = Ember.Mixin.create
  session: Ember.inject.service('session')
  currentUser: Ember.inject.service()

  beforeModel: ->
    @_super(arguments...)
    @get('currentUser').ensureUser().then =>
      lang = @get('currentUser.user.language')
      # @transitionTo 'set-language' unless lang


`export default EnsureLanguageSetMixin`
