`import Ember from 'ember'`
`import KeyboardShortcuts from 'ember-keyboard-shortcuts/mixins/component';`

CommentsWrapperComponent = Ember.Component.extend KeyboardShortcuts,
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  keyboardShortcuts: Ember.computed 'currentUser.disableShortcuts', ->
    if @get('currentUser.disableShortcuts') then return {}
    else
      {
      # open / close comments #
        'ctrl+alt+c': 'toggleComments'
      }
  init: ->
    this._super()
  isDisplayed: false
  moveComments: ->
    offsetFromWindow = Ember.$(window).scrollTop()
    top = Math.max(0, (Ember.$('.notifications').height() + Ember.$('.main-header').height() + 20 - offsetFromWindow))
    if offsetFromWindow < 96
      top += 20
    Ember.$('.sidebar').css('margin-top', "#{top}px")
  didInsertElement: ->
    Ember.$(window).on('scroll', @moveComments)
    @moveComments()
  willDestroyElement: ->
    Ember.$(window).off('scroll', @moveComments)

  actions:
    toggleComments: ->
      @toggleProperty('isDisplayed')


`export default CommentsWrapperComponent`
