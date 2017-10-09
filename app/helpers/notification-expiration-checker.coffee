`import Ember from 'ember'`

# This function receives the params `params, hash`
notificationExpirationChecker = (params) ->
  now = new Date(Date.now())
  now.setHours(0,0,0,0)
  date = new Date(params[0])
  date.setHours(0,0,0,0)

  date>=now

NotificationExpirationCheckerHelper = Ember.Helper.helper notificationExpirationChecker

`export { notificationExpirationChecker }`

`export default NotificationExpirationCheckerHelper`
