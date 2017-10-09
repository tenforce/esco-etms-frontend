`import Ember from 'ember'`
`import env from '../config/environment'`

InverseRelationElementComponent = Ember.Component.extend
  store: Ember.inject.service()

  editable: Ember.computed.not 'concept.disableEditing'

  inverseRelationsToDisplay: Ember.computed 'inverseRelations', ->
    @computeElementView()

  creationConceptOptions: Ember.computed ->
    options = env.creationConceptOptions
    conceptOptions = []
    type = @get 'type'
    if type is 'occupation'
      conceptOptions.pushObject(options.occupation)
    else if type is 'skill'
      conceptOptions.pushObject(options.skill)
    else if type is 'knowledge'
      conceptOptions.pushObject(options.knowledge)
    conceptOptions

  searchFilter: Ember.computed ->
    skillType = @get 'skillType'
    if skillType
      typeString = switch skillType
        when env.relationshipTypes.KNOWLEDGE_IRI then "knowledge"
        when env.relationshipTypes.SKILL_IRI then "skill"
      include: ["skillType:*" + typeString]

  computeElementView: ->
    @get('inverseRelations').then (relations) =>
      Ember.RSVP.all(relations).then (ps) =>
        items = []
        ps.map (hash) =>
          type = hash.relation.get('type')
          item = hash.target
          if @checkRelationType(type)
            item = hash.target
            if @checkType(item)
              items.push item
        items

  checkType: (concept) ->
    type = @get 'type'
    if type is 'occupation'
      return concept.get('isOccupation')
    else if type is 'skill'
      return concept.get('isSkillSkill')
    else if type is 'knowledge'
      return concept.get('isSkillKnowledge')
    false

  checkRelationType: (relation) ->
    @get('relationType') in relation

  updateElementView: ->
    @set 'inverseRelationsToDisplay', @computeElementView()


  actions:
    deleteRelation: (relation) ->
      @get('concept.inverseRelations').then (relationIt) =>
        relationIt.forEach (item, i) =>
          if item
            if((Ember.get(item, 'from.id') == Ember.get(relation, 'id')) or Ember.get(item, 'to.id') == Ember.get(relation, 'id'))
              item.destroyRecord()
              relationIt.removeObject(item)
      false

    saveAllElements: (items) ->
      # OPTIONAL_SKILL_IRI / ESSENTIAL_SKILL_IRI
      relationshipType = @get 'relationType'
      if relationshipType
        @get('inverseRelationsToDisplay').then (invRels) =>
          items.forEach (item) =>
            newRelation = @get('store').createRecord('conceptRelation',{
              type: [relationshipType],
              from: item,
              to: @get('concept')
              })
            newRelation.save()
            invRels.pushObject(item)
      else
        console.log 'error: no skilluri'
      false

    transitionToCreate: ->
      @sendAction('transitionToCreate', @get('type'), @get('relationType'))




`export default InverseRelationElementComponent`
