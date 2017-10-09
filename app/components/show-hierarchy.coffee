`import Ember from 'ember'`
`import env from '../config/environment'`

ShowHierarchyComponent = Ember.Component.extend
  tagName: ''

  hierarchyService: Ember.inject.service()
  structureId: Ember.computed.alias 'hierarchyService.selectedHierarchy.id'
  conceptScheme: Ember.computed ->
    @get('object.conceptSchemeId')

  showNarrower: Ember.computed 'presetNarrower', ->
    (@get('presetNarrower') is undefined) or (@get('presetNarrower') is true)

  isHierarchyEmpty: Ember.computed 'presetBroader', 'showNarrower', ->
    @get('presetBroader') and not @get('showNarrower')

  creationConceptOptions: Ember.computed ->
    options = env.creationConceptOptions
    switch
      when @get('object.isOccupation')     then [options.occupation]
      when @get('object.isSkillKnowledge') then [options.knowledge]
      when @get('object.isSkillSkill')     then [options.skill]

  disableEditingNarrower: Ember.computed.oneWay 'object.disableEditing'
  disableEditingBroader: Ember.computed.oneWay 'object.disableEditing'

  # can be overridden by consumer
  saveAfterAddingBroader: true
  saveAfterAddingNarrower: true

  actions:
    transitionToCreateBroader: ->
      @sendAction('transitionToCreate', 'broader')
    transitionToCreateNarrower: ->
      @sendAction('transitionToCreate', 'narrower')

`export default ShowHierarchyComponent`
