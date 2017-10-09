`import Ember from 'ember'`

ShowNotificationsComponent = Ember.Component.extend
  tagName: ''
  closedNotifications: 0
  displayNotifications: true
  checkEmpty: Ember.observer('closedNotifications', 'notifications.length', () ->
      @get('notifications').then (data) =>
          if @get('closedNotifications') >= data.get('length')
              @set('displayNotifications', false)
  ).on('init')

  store: Ember.inject.service('store')

  notifications: Ember.computed ->
        #  return this.store.filter('color', function(color) {
        #   return color.get("isNew") === false;
        # })
        # @get('store').filter 'notification', (notif)->
        #     notif.get("isNew") ==false
    @get('store').findAll('notification')

  actions:
    closeNotifications: ->
      @set 'displayNotifications', false
    closeNotification: ->
      @set('closedNotifications', @get('closedNotifications')+1)

`export default ShowNotificationsComponent`
