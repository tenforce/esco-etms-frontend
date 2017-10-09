`import Ember from 'ember'`
`import HierarchyConfig from '../mixins/hierarchy-config'`
`import env from '../config/environment'`

ConceptsController = Ember.Controller.extend HierarchyConfig,
  store: Ember.inject.service()
  browserChecker: Ember.inject.service()
  currentUser: Ember.inject.service()
  disableShortcuts: Ember.computed.alias 'currentUser.disableShortcuts'
  hierarchyService: Ember.inject.service()
  oldTarget: ""

  activateItem: (item) ->
    @transitionToRoute('concepts.show', item.get('id'))

  taxonomies: Ember.computed ->
    [
      {
        label: "Occupations",
        id: env.etms.occupationScheme,
        options: env.creationConceptOptions.occupation
      },
      {
        label: "Skills",
        id: env.etms.skillScheme,
        options: env.creationConceptOptions.skill
      }
    ]

  selectedTaxonomy: Ember.computed 'taxonomies', 'model.id', ->
    id = @get 'model.id'
    @get('taxonomies').filterBy("id", id )[0]


  actions:
    selectTaxonomy: (taxonomy) ->
      @transitionToRoute('concepts', taxonomy.id).then (transition) =>
        if(@get('browserChecker').get('isExplorer'))
          @get('store').unloadAll('concept')


    activateItem: (item) ->
      @activateItem(item)

    goToCreate: (options) ->
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller
        controller?.set 'chosenType', options

    toggleDisplayInChosenLanguage: ->
      if @get('user.showIscoInChosenLanguage') is 'yes'
        @set('user.showIscoInChosenLanguage', 'no')
      else if @get('user.showIscoInChosenLanguage') is 'no'
        @set('user.showIscoInChosenLanguage', 'yes')
      else if @get('user.showIscoInChosenLanguage') is undefined
        @set('user.showIscoInChosenLanguage', 'yes')


`export default ConceptsController`
