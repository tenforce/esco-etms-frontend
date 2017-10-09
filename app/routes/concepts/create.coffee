`import Ember from 'ember'`

ConceptsCreateRoute = Ember.Route.extend

  model: (params) ->
    @get('store').query('publicationStatus', {filter: {'label': 'draft'}}).then((status) =>
      status.get('firstObject')).then (status) =>
        @store.createRecord('concept', {
          description: [{content: "", language: "en"}],
          isUnderCreation: true,
          isEditable: 'true',
          disableEditing: false
          hasPublicationStatus: status
          taxonomy: [],
          types: [],
          prefLabels: [],
          altLabels: [],
          hiddenLabels: []
        })
  afterModel: (model) ->
    window.scrollTo(0, 0)

  setupController: (controller, model) ->
    @_super(controller, model)
    # If only one type of concept can be created here, automatically select it.
    if controller.get('conceptOptions').length == 1
      controller.set 'chosenType', controller.get('conceptOptions')[0]
    controller.set 'contextMessage', undefined
    controller.set 'resourcesBefore', []
    controller.set 'resourcesAfter', []
    controller

  resetController: (controller, isExiting, transition) ->
    @_super(controller, isExiting, transition)
    controller.set 'contextMessage', undefined
    controller.set 'resourcesBefore', []
    controller.set 'resourcesAfter', []
    controller.set 'chosenType', null
    controller

  actions:
    willTransition: (transition) ->
      if @controller.get('suppressTransitionWarning')
        true
      else
        if !confirm("You didn't finish creating the concept.\nLeave anyways?")
          transition.abort()
        else
          true

`export default ConceptsCreateRoute`
