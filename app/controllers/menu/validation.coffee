`import Ember from 'ember'`
`import env from '../../config/environment'`

ValidationController = Ember.Controller.extend
  queryParams: ['platform']
  platform: 'etms'

  # TODO : Once Aad has fixed the issue with the GROUP BY when sorting, set it back to true
  # whether the results from validation should be sorted
  sortResultTable: false
  timeOut: Ember.computed ->
    return env.validationTimeOut

  baseURL: Ember.computed ->
    return env.baseURL

  actions:
      onConceptClick: (validation) ->
        @get('store').find('concept', validation.get('parameterUuid')).then (concept) =>
          if concept.get('isOccupation') then scheme = env.etms.occupationScheme
          # Check if switch to skill is disabled !
          else if concept.get('isSkill') then unless env.etms.disableTaxonomyChange then scheme = env.etms.skillScheme
          if scheme then @transitionToRoute('concepts.show', scheme, validation.get('parameterUuid'))
`export default ValidationController`
