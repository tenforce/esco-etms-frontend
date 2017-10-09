`import Ember from 'ember'`
`import KeyboardShortcuts from 'ember-keyboard-shortcuts/mixins/component';`

NotificationRelatedItemComponent = Ember.Component.extend KeyboardShortcuts,
  tagName: 'li'
  classNames: ['related-item']

  currentUser: Ember.inject.service()
  keyboardShortcuts: Ember.computed 'currentUser.disableShortcuts', ->
    if @get('currentUser.disableShortcuts') then return {}
    else
    {
      'ctrl+alt+d':
        action: 'deleteRelatedItem'
        scoped: true
    }

  actions:
    textContentModified: (index, event) ->
      @sendAction('textContentModified', index, event)

    deleteRelatedItem: ->
      if @get('relatedItem') then @set 'relatedItem', ''
      else @sendAction('removeRelatedItem', @get('index'))

    removeRelatedItem: (index) ->
      @sendAction('removeRelatedItem', index)

`export default NotificationRelatedItemComponent`
