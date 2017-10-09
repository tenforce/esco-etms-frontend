`import Ember from 'ember'`
`import env from '../config/environment'`
`import clearHierarchyCache from '../utils/clear-hierarchy-cache'`

ConceptCreatorComponent = Ember.Component.extend
  store: Ember.inject.service('store')
  hierarchyService: Ember.inject.service('hierarchyService')
  saveAllButton: Ember.inject.service()

  # The dummy object that's build on while creating the concept
  newConcept: null

  # Show an error message, for when not enough data is entered to save the concept.
  showSavingError: false

  # Which concept types are available for creation.
  conceptOptions: []

  # The chosen concept type, selected from conceptOptions.
  chosenType: null

  # When a concept type is set, it can't be changed.
  disableSelector: Ember.computed 'chosenType', ->
    @get('chosenType') != null

  # A concept can be created iff a broader is defined.
  # When creating it from a narrower relationship, the broader should be preset and can't be overridden.
  presetBroader: false

  # Don't show the Narrower tab when creating concepts.
  presetNarrower: false

  init: ->
    @_super()
    # If only one type of concept can be created here, automatically select it.
    if @get('conceptOptions').length == 1
      @set 'chosenType', @get('conceptOptions')[0]
      @createNewConcept()


  # Start with creating the concept.
  createNewConcept: ->
    # get selected conceptScheme. string representation (occupationScheme|skillScheme)
    conceptScheme = @get 'chosenType.conceptScheme'

    # set schemeId to uuid.
    if conceptScheme is 'occupationScheme'
      @set 'schemeId', env.etms.occupationScheme
    else if conceptScheme is 'skillScheme'
      @set 'schemeId', env.etms.skillScheme

    # get the taxonomy object from the store
    @get('store').findRecord('concept-scheme', @get('schemeId')).then (taxonomy) =>
      # retrieve the draft publication status DS object
      @get('store').query('publicationStatus', {filter: {'label': 'draft'}})
        .then((status) => status.get('firstObject')).then (status) =>

          # make a stub for a new concept DS object
          newconcept = @get('store').createRecord('concept', {
            description: [{content: "", language: "en"}],
            isUnderCreation: true,
            isEditable: 'true',
            taxonomy: [taxonomy],
            hasPublicationStatus: status
            types: @get('chosenType.types'),
            skillType: @get('chosenType.skillType'),
            })

          @set('newConcept', newconcept)
          @set('conceptCreated', true)

  saveTerms: (concept) ->
    save = (prom_list) ->
      prom_list?.then (list) ->
        list.forEach (term) ->
          term.save()
    promises = []
    promises.push save(concept?.get('localizedPrefLabels'))
    promises.push save(concept?.get('localizedAltLabels'))
    promises.push save(concept?.get('localizedHiddenLabels'))
    return Ember.RSVP.Promise.all(promises)
  deleteTerms: (concept) ->
    del = (prom_list) ->
      prom_list?.then (list) ->
        list.forEach (term) ->
          term.destroyRecord()
    promises = []
    promises.push del(concept?.get('localizedPrefLabels'))
    promises.push del(concept?.get('localizedAltLabels'))
    promises.push del(concept?.get('localizedHiddenLabels'))
    return Ember.RSVP.Promise.all(promises)
  actions:
    # A concept type is selected
    selectType: (chosen) ->
      @set 'chosenType', chosen
      @createNewConcept()
      false

    # The cancel button is clicked, the temporary concept must be removed.
    cancelCreate: ->
      @deleteTerms(@get('newConcept')).then (res) =>
          @get('newConcept').destroyRecord().then (rec)=>
            @sendAction('cancelCreate')

    # The save button is clicked
    save: ->
      unless @get('presetBroader') || @get('newConcept.broader.length') > 0 # if we have one broader
        @set 'showSavingError', true
        return
      preflabels = @get('newConcept.localizedPrefLabels') # and we have a preflabel
      preflabels.then (preflabels) =>
        unless preflabels.get('firstObject.literalForm.length') > 0
          @set 'showSavingError', true
          return
        @get('saveAllButton').saveAll()
        @set 'newConcept.isUnderCreation', false
        @get('newConcept').save().then (res) =>
          @saveTerms(@get('newConcept')).then =>
            clearHierarchyCache().then () =>
              @get('hierarchyService')._clearCache()  # Clear the hierarchy cache in hierarchyService (ember-esco-plugins)
              broader = @get('newConcept.broader.firstObject')
              if broader isnt undefined # Concept was created and a broader was specified, we tickle the broader to refetch children.
                broader.set('dirty', true)
              @sendAction('savedNewConcept', @get('newConcept'), @get('schemeId'))


`export default ConceptCreatorComponent`
