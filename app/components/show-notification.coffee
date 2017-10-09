`import Ember from 'ember'`

ShowNotificationComponent = Ember.Component.extend
  tagName: ''
  displayNotification: true
  listClosed: true

  actions:
    closeNotification: ->
      @set('displayNotification', false)
      @sendAction('closeNotification')
    toggleList: ->
      @toggleProperty('listClosed')

`export default ShowNotificationComponent`
