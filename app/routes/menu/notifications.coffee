`import Ember from 'ember'`
`import UserRights from '../../mixins/user-rights'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../../mixins/ensure-language-set'`
`import env from '../../config/environment'`

NotificationsRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin, UserRights,

  allowedOnNotifications: Ember.computed 'userIsAdmin', ->
    @get('userIsAdmin')
  allowedOnValidation: Ember.computed 'userIsAdmin', 'userIsReviewer', ->
    @get('userIsAdmin') or @get('userIsReviewer')
  model: (params) ->
    @set('params', params)
  afterModel: (transition) ->
    @_super(arguments...)
    unless @get 'allowedOnNotifications'
      alert('Only administrators can see the notifications.');
      if transition then transition.abort()
      else @transitionTo('concepts', env.etms.occupationScheme)
  setupController: (controller, model) ->
    controller.set('display', @get('params.display'))
    @_super(controller, model)


`export default NotificationsRoute`
