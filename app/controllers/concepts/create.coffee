`import Ember from 'ember'`
`import env from '../../config/environment'`
`import clearHierarchyCache from '../../utils/clear-hierarchy-cache'`

ConceptsCreateController = Ember.Controller.extend
  notify: Ember.inject.service('notify')
  hierarchyService: Ember.inject.service('hierarchyService')
  saveAllButton: Ember.inject.service()

  creationConceptOptions: Ember.computed ->
    options = env.creationConceptOptions
    conceptOptions = []
    conceptOptions.pushObject(options.occupation)
    conceptOptions.pushObject(options.skill)
    conceptOptions.pushObject(options.knowledge)
    conceptOptions

  suppressTransitionWarning: false

  disableEditingBroader: false
  disableEditingNarrower: false

  # The dummy object that's build on while creating the concept
  newConcept: Ember.computed.alias 'model'

  # Show an error message, for when not enough data is entered to save the concept.
  showSavingError: false

  # Which concept types are available for creation.
  conceptOptions: []

  # The chosen concept type, selected from conceptOptions.
  chosenType: null
  chosenTypeObserver: Ember.observer 'chosenType', (->
    chosenType = @get('chosenType')
    concept = @get('model')
    if chosenType and concept
      @set('updatingConceptType', true)
      conceptScheme = chosenType.conceptScheme
      # set schemeId to uuid.
      if conceptScheme is 'occupationScheme'
        @set 'schemeId', env.etms.occupationScheme
      else if conceptScheme is 'skillScheme'
        @set 'schemeId', env.etms.skillScheme
      @get('store').findRecord('concept-scheme', @get('schemeId')).then (taxonomy) =>
        concept.set('types', chosenType.types)
        concept.set('taxonomy', [taxonomy])

        promises = []
        if chosenType?.regulatedConceptUuid
          promises.push(@get('store').findRecord('concept', chosenType.regulatedConceptUuid).then (regulated) =>
            if regulated?.get('id')
              concept.set('underRegulation', regulated)
          )

        # TODO : replace
        if chosenType?.skillType
          promises.push (@get('store').findRecord('concept', chosenType.skillTypeConceptUuid).then (skilltypeconcept) =>
            if skilltypeconcept?.get('id')
              concept.set('skillTypeConcept', skilltypeconcept)
              concept.set('skillType', chosenType.skillType)
          )

        Ember.RSVP.Promise.all(promises).then =>
          @set('updatingConceptType', false)

  ).on('init')
  updatingConceptType: true

  # When a concept type is set, it can't be changed.
  disableSelector: Ember.computed 'chosenType', ->
    @get('chosenType') != null

  defaultContextMessage: Ember.computed 'model.isOccupation', 'model.isSkill', ->
    if @get('model.isOccupation') then type = "occupation"
    else if @get('model.isSkill') then type = "KSC concept"
    else type = "concept"

    return "Creating new #{type}"
  contextMessage: undefined
  displayedContextMessage: Ember.computed 'contextMessage', 'defaultContextMessage', ->
    msg = @get('contextMessage')
    if msg then return msg
    return @get('defaultContextMessage')

  # A concept can be created iff a broader is defined.
  # When creating it from a narrower relationship, the broader should be preset and can't be overridden.
  presetBroader: false

  # Don't show the Narrower tab when creating concepts.
  presetNarrower: false

  resourcesBefore: []
  resourcesAfter: []
  saveResources: (resources) ->
    promises = []
    resources?.forEach (resource) ->
      promises.push(resource?.save())
    Ember.RSVP.Promise.all(promises)
  deleteResources: (resources) ->
    promises = []
    resources?.forEach (resource) ->
      # if the resource has already been persisted, we don't want to just delete it
      unless resource.get('id')
        promises.push(resource?.destroyRecord())
    Ember.RSVP.Promise.all(promises)

  originScheme: Ember.computed.oneWay 'hierarchyService.taxonomy'
  originConcept: Ember.computed.oneWay 'hierarchyService.target'
  targetScheme: Ember.computed.oneWay 'schemeId'
  targetConcept: Ember.computed.oneWay 'newConcept.id'

  actions:
    # A concept type is selected
    selectType: (chosen) ->
      @set 'chosenType', chosen
      false

    # The cancel button is clicked, the temporary concept must be removed.
    cancelClicked: ->
      promises = []
      promises.push (@deleteResources(@get('resourcesBefore')))
      promises.push (@deleteResources(@get('resourcesAfter')))
      promises.push (@get('newConcept').destroyRecord())
      Ember.RSVP.Promise.all(promises).then =>
        @set 'suppressTransitionWarning', true
        scheme = @get('originScheme')
        item = @get('originConcept')
        switch
          when scheme && item then @transitionToRoute('concepts.show', scheme, item)
          when scheme then @transitionToRoute('concepts', scheme)
          else @transitionToRoute('application')
        false

    # The save button is clicked
    saveClicked: ->
      unless @get('presetBroader') || @get('newConcept.broader.length') > 0 # if we have one broader
        @get('notify').error('You need to specify a broader relation to save this concept.')
        return
      preflabels = @get('newConcept.localizedPrefLabels') # and we have a preflabel
      preflabels.then (preflabels) =>
        unless preflabels.get('firstObject.literalForm.length') > 0
          @get('notify').error('You need to specify a preferred term to save this concept.')
          return
        console.log "starting -- saving resources needed before saving the concept"
        @saveResources(@get('resourcesBefore')).then =>
          console.log "done -- saving resources needed before saving the concept"
          console.log "starting -- saving concept"
          @get('saveAllButton').saveAll()
          @set 'newConcept.isUnderCreation', false
          @get('newConcept').save().then (res) =>
            console.log "done -- saving concept"
            console.log "starting -- saving resources needed after saving the concept"
            @saveResources(@get('resourcesAfter')).then =>
              console.log "done -- saving resources needed after saving the concept"
              console.log "starting -- removing resources"
              @set('resourcesBefore', [])
              @set('resourcesAfter', [])
              console.log "done -- removing resources"
              clearHierarchyCache().then () =>
                @get('hierarchyService')._clearCache()  # Clear the hierarchy cache in hierarchyService (ember-esco-plugins)
                broaders = @get('newConcept.broader')
                broaders.forEach (broader) ->
                  broader.set('dirty', true)
                @set 'suppressTransitionWarning', true
                @transitionToRoute('concepts.show', @get('targetScheme'), @get('targetConcept'))
                false

    removeTerm: (term) ->
      @get('resourcesAfter')?.remove(term)
    addTerm: (term) ->
      @get('resourcesAfter')?.push(term)

    saveSkillType: (newtype, oldtype, save) ->
      model = @get('model')
      unless model then return false
      model.addPropertyToSave('skillTypeConcept', 'skill type', newtype, oldtype)
      if save then return model.save()
      model

    saveSkillReuseLevel: (newtype, oldtype, save) ->
      model = @get('model')
      unless model then return false
      model.addPropertyToSave('skillReuseLevel', 'skill reuse level', newtype, oldtype)
      if save then return model.save()
      model

    saveValue: (propname, dispname, newvalue, oldvalue, save) ->
      model = @get('model')
      unless model then return false
      model.addPropertyToSave(propname, dispname, newvalue, oldvalue)
      if save then return model.save()
      model

`export default ConceptsCreateController`
