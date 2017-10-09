`import Ember from 'ember'`

NotificationsListComponent = Ember.Component.extend
  store: Ember.inject.service('store')
  emptyNotifications: Ember.computed 'notifications', ->
    @get('notifications').then (notifications) ->
      if notifications?.get('length') > 0 then return false
      else return true
  notifications: Ember.computed 'showExpiredNotifications',  ->
    @getNotifications()
  showExpiredNotifications: false
  getNotifications: () ->
    showexpired = @get 'showExpiredNotifications'
    @get('store').findAll('notification').then (notifications) =>
      if showexpired then return notifications
      curdate = new Date()
      curdate.setHours(0)
      curdate.setMinutes(0)
      curdate.setSeconds(0)
      curdate.setMilliseconds(0);
      res = notifications.filter (notif) ->
        notifdate = new Date(notif.get('expirationDate'))
        if notifdate.getTime() >= curdate.getTime() then return true
        else return false
      return res
  refresh: () ->
    @set 'notifications', @getNotifications()


  actions:
    setShowExpiredNotifications: (bool) ->
      @set 'showExpiredNotifications', bool
    update: (notification) ->
      @sendAction('update', notification)
    delete: (notification) ->
      notification.deleteRecord()
      notification.save().then =>
        @refresh()

`export default NotificationsListComponent`
