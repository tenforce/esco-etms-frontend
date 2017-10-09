`import Ember from 'ember'`
`import KeyboardShortcuts from 'ember-keyboard-shortcuts/mixins/component';`

HelpBoxWrapperComponent = Ember.Component.extend KeyboardShortcuts,
  currentUser: Ember.inject.service()
  keyboardShortcuts: Ember.computed 'currentUser.disableShortcuts', ->
    if @get('currentUser.disableShortcuts') then return {}
    else
      {
        'f1':
          action: 'toggleHelp'
          preventDefault: true
        'F1':
          action: 'toggleHelp'
          scoped: true
          preventDefault: true
      }
  toggleHelp: false
  actions:
    toggleHelp: ->
      @toggleProperty('toggleHelp')
    closeHelp: ->
      @set 'toggleHelp', false

`export default HelpBoxWrapperComponent`
