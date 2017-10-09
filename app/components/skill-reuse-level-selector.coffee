`import Ember from 'ember'`
`import env from '../config/environment'`
`import sortByPromise from '../utils/sort-by-promise'`

SkillReuseLevelSelectorComponent = Ember.Component.extend
  classNames: ['skill-reuse-level']
  classNameBindings: ['savedAndNotDirty:saved', 'model.skillReuseLevelFailed:failed', 'dirty:dirty']
  store: Ember.inject.service()
  saveAllButton: Ember.inject.service()

  init: ->
    @_super()
    @get('saveAllButton').subscribe(@)

  willDestroyElement: ->
    @_super()
    @get('saveAllButton').unsubscribe(@)

  savedAndNotDirty: Ember.computed 'dirty', 'model.skillReuseLevelSaved', ->
    if @get('dirty') then return false
    return @get('model.skillReuseLevelSaved')

  schemeId: Ember.computed ->
    env.etms.skillReuseLevelScheme
  members: Ember.computed 'schemeId', ->
    @get('store').findOneQuery('concept-scheme', @get('schemeId'), {}).then (taxonomy) ->
      taxonomy.get('members').then (members) ->
        sortByPromise(members, 'localizedPrefLabel').then (members) ->
          return members
  modelSkillReuseLevel: Ember.computed.alias 'model.skillReuseLevel'
  selectedLevel: Ember.computed.oneWay 'modelSkillReuseLevel'
  dirty: false
  dirtyObserver: Ember.observer 'modelSkillReuseLevel.id', 'selectedLevel.id', ->
    Ember.RSVP.hash(
      model: @get('modelSkillReuseLevel')
      selected: @get('selectedLevel')
    ).then (hash) =>
      dirty = hash.model?.get('id') != hash.selected?.get('id')
      unless @get('isDestroyed')
        @set('dirty', dirty)
  showActions: true
  disabled: false
  disabledSelect: false

  saveAllClick: ->
    @handleSave(false)
  resetAllClick: ->
    @handleRollback(false)
  handleSave: (save) ->
    unless @get('disabled')
      @sendAction('saveSkillReuseLevel', @get('selectedLevel'), @get('modelSkillReuseLevel'), save)
  handleRollback: (save) ->
    unless @get('disabled')
      @set('selectedLevel', @get('modelSkillReuseLevel'))
  actions:
    selectLevel: (level) ->
      @set('selectedLevel', level)
    saveSkillReuseLevel: ->
      @handleSave(true)
    rollbackSkillReuseLevel: ->
      @handleRollback(true)
`export default SkillReuseLevelSelectorComponent`
