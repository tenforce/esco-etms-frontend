`import Ember from 'ember'`
`import KeyboardShortcuts from 'ember-keyboard-shortcuts/mixins/component';`

HelpBoxComponent = Ember.Component.extend KeyboardShortcuts,
  classNames: ['help-dialog']
  currentUser: Ember.inject.service()
  keyboardShortcuts: Ember.computed 'currentUser.disableShortcuts', ->
    if @get('currentUser.disableShortcuts') then return {}
    else
      {
        'esc':
          action: 'closeHelp'
      }

  selectedTab: Ember.computed ->
    @get('tabs')[0]
  tabs:
    [
      {
        label: 'Shortcuts'
        component: 'tab-shortcuts'
      }
      {
        label: 'Genders input'
        component: 'tab-genders'
      }
    ]
  actions:
    closeHelp: ->
      @sendAction('closeHelp')
    selectTab: (tab) ->
      @set 'selectedTab', tab

`export default HelpBoxComponent`
