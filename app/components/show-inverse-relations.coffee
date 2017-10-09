`import Ember from 'ember'`
`import env from '../config/environment'`

ShowInverseRelationsComponent = Ember.Component.extend
  OPTIONAL_SKILL_IRI:  env.relationshipTypes.OPTIONAL_SKILL_IRI
  ESSENTIAL_SKILL_IRI: env.relationshipTypes.ESSENTIAL_SKILL_IRI
  SKILL_SKILL_IRI:     env.relationshipTypes.SKILL_SKILL_IRI
  KNOWLEDGE_SKILL_IRI: env.relationshipTypes.KNOWLEDGE_SKILL_IRI

  init: ->
    @_super()
    @get('object.inverseRelations').then (relations) ->
      relations.reload()

  inverseRelations: Ember.computed 'object.inverseRelations', ->
    @get('object.inverseRelations').then (relations) ->
      relations = relations.map (item) ->
        Ember.RSVP.hash({target: item.get('from'), relation: item})
      relations

  occupationScheme: Ember.computed ->
    env.etms.occupationScheme
  skillScheme: Ember.computed ->
    env.etms.skillScheme

  actions:
    transitionToCreate: (skilltype, relationtype) ->
      @sendAction('transitionToCreate', skilltype, relationtype)
`export default ShowInverseRelationsComponent`
