`import Ember from 'ember'`
`import env from '../config/environment'`
`import sortByPromise from '../utils/sort-by-promise'`

SkillTypeSelectorComponent = Ember.Component.extend
  classNames: ['skill-type']
  classNameBindings: ['savedAndNotDirty:saved', 'model.skillTypeConceptFailed:failed', 'dirty:dirty']
  store: Ember.inject.service()
  saveAllButton: Ember.inject.service()

  init: ->
    @_super()
    @get('saveAllButton').subscribe(@)

  willDestroyElement: ->
    @_super()
    @get('saveAllButton').unsubscribe(@)

  savedAndNotDirty: Ember.computed 'dirty', 'model.skillTypeConceptSaved', ->
    if @get('dirty') then return false
    return @get('model.skillTypeConceptSaved')

  schemeId: Ember.computed ->
    env.etms.skillTypeScheme
  members: Ember.computed 'schemeId', ->
    @get('store').findOneQuery('concept-scheme', @get('schemeId'), {}).then (taxonomy) ->
      taxonomy.get('members').then (members) ->
        sortByPromise(members, 'localizedPrefLabel').then (members) ->
          return members
  modelSkillType: Ember.computed.alias 'model.skillTypeConcept'
  selectedType: Ember.computed.oneWay 'modelSkillType'
  dirty: false
  dirtyObserver: Ember.observer 'modelSkillType.id', 'selectedType.id', ->
    Ember.RSVP.hash(
      model: @get('modelSkillType')
      selected: @get('selectedType')
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
      @sendAction('saveSkillType', @get('selectedType'), @get('modelSkillType'), save)
  handleRollback: (save) ->
    unless @get('disabled')
      @set('selectedType', @get('modelSkillType'))
  actions:
    selectType: (type) ->
      @set('selectedType', type)
    saveSkillType: ->
      @handleSave(true)
    rollbackSkillType: ->
      @handleRollback(true)

`export default SkillTypeSelectorComponent`
