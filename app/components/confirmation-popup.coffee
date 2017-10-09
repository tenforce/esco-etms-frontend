`import Ember from 'ember'`

ConfirmationPopupComponent = Ember.Component.extend
  disabled: false
  actions:
    confirm: ->
      @sendAction('confirmAction')
    cancel: ->
      @sendAction('closeConfirmation')

`export default ConfirmationPopupComponent`
