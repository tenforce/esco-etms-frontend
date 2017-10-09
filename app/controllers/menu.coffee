`import Ember from 'ember'`
`import UserRights from '../mixins/user-rights'`

MenuController = Ember.Controller.extend UserRights,
    session: Ember.inject.service('session')
    # percentages: Ember.computed.alias 'tasks.percentages'

    allowedOnNotifications: Ember.computed 'userIsAdmin', ->
      @get('userIsAdmin')
    allowedOnValidation: Ember.computed 'userIsAdmin', 'userIsReviewer', ->
      @get('userIsAdmin') or @get('userIsReviewer')
    allowedOnPublish: Ember.computed 'userIsAdmin', 'userIsReviewer', ->
      @get('userIsAdmin') or @get('userIsReviewer')
    allowedOnBookmarks: true
    allowedOnPublication: Ember.computed.alias 'userIsAdmin'
    allowedOnDashboard: true

    # TODO find a way to set these based on the route
    showDashboardSubmenu: true
    showNotificationSubmenu: true

`export default MenuController`
