`import Ember from 'ember'`
`import env from '../config/environment'`

WrapperSkillsComponent = Ember.Component.extend
  tagName: ''

  skillScheme: Ember.computed ->
    env.etms.skillScheme

  creationConceptOptions: Ember.computed ->
    options = env.creationConceptOptions
    conceptOptions = []
    skillType = @get('skillType') # URI rep. Using indexOf to figure out skillType
    if skillType.indexOf("http://data.europa.eu/esco/skill-type/skill")>=0
      conceptOptions.pushObject(options.skill)
    else if skillType.indexOf("http://data.europa.eu/esco/skill-type/knowledge")>=0
      conceptOptions.pushObject(options.knowledge)
    conceptOptions

  actions:
    transitionToCreate: (type)->
      @sendAction('transitionToCreate', type)

`export default WrapperSkillsComponent`
