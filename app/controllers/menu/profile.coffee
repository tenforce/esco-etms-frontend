`import Ember from 'ember'`
`import {languages} from '../../utils/languages'`
`import UserRights from '../../mixins/user-rights'`

ProfileController = Ember.Controller.extend UserRights,
  userGroupTexts: Ember.computed 'userIsAdmin', 'userIsTranslator', ->
    if(@get('userIsAdmin') and @get('userIsTranslator'))
      return 'BASIC USER, ADMIN'
    else if @get('userIsAdmin')
      return 'ADMIN'
    else if @get('userIsTranslator')
      return 'BASIC USER'
    ""

  classNames: ["main-header"]
  languages: languages

  name: Ember.computed.oneWay "user.name"
  toggleBooleanProp: (name) ->
    current = @get name
    if current == "yes"
      @set name, "no"
    else
      @set name, "yes"

  disableShortcutsLabel: Ember.computed 'user.disableShortcuts', ->
    if @get('user.disableShortcuts') is "no" then return "Shortcuts are enabled"
    else if @get('user.disableShortcuts') is "yes" then return "Shortcuts are disabled"

  actions:
    toggleDisableShortcuts: ->
      @toggleBooleanProp("user.disableShortcuts")
    updateProfile: ->
      @set 'loading', true
      @set 'success', false
      user = @get('user')
      user.set('language', @get('language.id'))
      user.set('name', @get('name'))
      user.save().then(
        =>
          @set 'loading', false
          @set 'success', true
        ,
        =>
          @set 'loading', false
      )
    setName: (name) ->
      @set 'name', name

`export default ProfileController`
