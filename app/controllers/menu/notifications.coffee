`import Ember from 'ember'`

NotificationsController = Ember.Controller.extend
  # Set in the router
  display: null

  actions:
    update: (notification) ->
      @set 'selectedNotification', notification
      @set 'display', 'update'
    transitionToList: ->
      @set 'display', 'list'

`export default NotificationsController`
