`import Ember from 'ember'`
`import clearHierarchyCache from '../../utils/clear-hierarchy-cache'`
`import env from '../../config/environment'`

ConceptsShowController = Ember.Controller.extend
  store: Ember.inject.service()
  currentUser: Ember.inject.service()
  saveAllButton: Ember.inject.service()
  notify: Ember.inject.service('notify')
  hierarchyService: Ember.inject.service('hierarchyService')

  conceptScheme: Ember.computed 'model.isSkill', ->
    console.log 'todo - better way to get conceptSchemeId' # TODO how about a service?
    if @get 'model.isSkill'
      return env.etms.skillScheme
    return env.etms.occupationScheme

  occupationParameters: Ember.computed ->
    options = env.creationConceptOptions
    return options.occupation
  skillParameters: Ember.computed ->
    options = env.creationConceptOptions
    return options.skill
  knowledgeParameters: Ember.computed ->
    options = env.creationConceptOptions
    return options.knowledge

  disableShortcuts: Ember.computed.alias 'currentUser.disableShortcuts'
  user: Ember.computed.alias 'currentUser.user'
  conceptDeprecated: Ember.computed.alias 'model.isDeprecated'
  conceptDeleted: false
  showConfirmationPopup: false
  mergeFunctionalityFlag: true
  confirmTitle: ''
  confirmAction: ''
  confirmButton: ''
  dirty: Ember.computed.alias 'saveAllButton.dirty'

  getDeletion: Ember.observer('model.hasPublicationStatus', ->
    status = @get('model.hasPublicationStatus')
    promises = [status]
    Ember.RSVP.Promise.all(promises).then (labels) =>
      label = labels.get('firstObject.label')
      if label and (label is 'deleted')
        @set 'conceptDeleted', true
      else
        @set 'conceptDeleted', false).on('init')

  getReplacements: Ember.observer 'model.replaces', (->
    replaces = @get('model.replaces')
    if replaces
      replaces.then (replacedConcepts) =>
        labels = replacedConcepts.map (concept) -> { label: concept.get('defaultPrefLabel'), id: concept.get('id') }
        if labels.length >= 1
          @set 'buttonText', "Add more replaced concepts"
        else
          @set 'buttonText', "Replace it"
        @set 'replaces', labels.sort()
  ).on('init')

  hideInverseRelationsLabel: Ember.computed.not 'model.isSkill'
  hideDeprecation: Ember.computed.none 'model.issued' # true if null or undefined
  hideDelete: Ember.computed.or 'model.issued', 'conceptDeleted'

  targetLanguage: Ember.computed ->
    @get('currentUser.user.language')

  # Add elements to the merge replacements
  addElements: (items) ->
    @get('model.replaces').then (reps) =>
      items.forEach (item) =>
        item.get('replacements').then (replacements) =>
          replacements.pushObject @get('model')
          item.save()
        reps.pushObject(item)
      @get('model').save().then (savedM) =>
        @set 'buttonText', "Add more merge replacements"

  # Delete an element from the merge replacements
  deleteElement: (item) ->
    @get('model.replaces').then (replacements) =>
      replacements.forEach (concept, index) =>
        concept.get('defaultPrefLabel').then (label) =>
          if label == item
            replacements.removeAt(index)
            @get('model').save().then =>
              if replacements.length == 0
                @set 'buttonText', "Replace it"


  setConfirmation: (title, action, button, show) ->
    @set 'confirmTitle', title
    @set 'confirmAction', action
    @set 'confirmButton', button
    @set 'showConfirmationPopup', show

  closeConfirmation: ->
    @setConfirmation('','','',false)

  deprecateConcept: (concept) ->
    publications = @get('store').query('publicationStatus', {filter: {'label': 'ready for deprecation'}})
    promises = [publications]

    Ember.RSVP.Promise.all(promises).then (statuses) =>
      statuses.get('firstObject').forEach (status) =>
        label = status.get('label')
        if label == 'ready for deprecation'
          concept.set('hasPublicationStatus', status)
          concept.save()
    @deprecateOrDeleteNarrowers()

  deleteConcept: (concept)->
    @get('store').query('publicationStatus', { filter: {'label': 'deleted'} }).then (statuses) =>
      status = statuses.get('firstObject')
      label = status.get('label')
      if label == 'deleted'
        concept.set('hasPublicationStatus', status)
        concept.save()
    @deprecateOrDeleteNarrowers()

  deprecateOrDeleteNarrowers:  ->
    id = @get 'model.id'
    url = "/narrower-handler/" + id
    Ember.$.ajax
      url: url,
      type: "GET",
      success: (ret) =>
        promises = []

        # Clear mu-resources cache.
        promises.push(
          new Ember.RSVP.Promise (resolve, reject) ->
            Ember.$.ajax
              url: '/cache/clear'
              type: 'POST'
              contentType: 'application/vnd.api+json'
              success: (result) ->
                resolve()
              error: (err) ->
                reject(err))

        promises.push Ember.RSVP.resolve @get('hierarchyService')._clearCache()
        promises.push clearHierarchyCache()

        Ember.RSVP.Promise.all(promises).then =>
          options = { include: "has-publication-status" }
          @store.findOneQuery('concept', @get('model.id'), options).then (concept) =>
            concept.get('narrower').then (narrowers) =>
              narrowers.forEach (narrower) =>
                @store.findOneQuery('concept', narrower.get('id'), options)
      error: (ret) ->
        console.log "Error occurred during deleting and deprecating the narrower concepts: " + ret


  actions:
    saveAllElements: (results) ->
      @addElements(results)
      false
    deleteRelation: (item) ->
      @deleteElement(item)
      false

    deprecateConcept: ->
      @closeConfirmation()
      @deprecateConcept(@get('model'))
      false

    deleteConcept: ->
      @closeConfirmation()
      @deleteConcept(@get('model'))
      @set 'conceptDeleted', true
      false

    closeConfirmation: ->
      @closeConfirmation()
      false

    confirmDeprecation: ->
      @setConfirmation('Do you want to deprecate this concept? This will change the publication status for each narrower too.','deprecateConcept','Ok',true)
      false

    confirmDeletion: ->
      @setConfirmation('Do you want to delete this concept? This will change the publication status for each narrower too.','deleteConcept','Ok',true)
      false

    saveAll: ->
      @get('saveAllButton').saveAll()
      @get('model')?.save().then((newmodel) ->
        newmodel?.reload()
      ).catch (reason) ->
        console.log "Failed to save all"

    transitionToCreateHierarchy: (type) ->
      console.log "transition to create received [#{type}]"
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller

        # setting type
        switch
          when @get('model.isOccupation')     then parameters = @get('occupationParameters')
          when @get('model.isSkillKnowledge') then parameters = @get('knowledgeParameters')
          when @get('model.isSkillSkill')     then parameters = @get('skillParameters')
        controller.set 'chosenType', parameters

        # generating context message
        label = @get('model.loadedDefaultPrefLabel')
        contextMessage = "Creating a new <strong>#{type}</strong> concept for <strong>#{label}</strong>"
        controller.set 'contextMessage', contextMessage

        # making sure we redirect to the old concept
        controller.set('targetScheme', @get('hierarchyService.taxonomy'))
        controller.set('targetConcept', @get('hierarchyService.target'))

        # preparing concept
        newconcept = controller.get('model')
        switch type
          when "broader"
            newconcept.set('narrower', [@get('model')])
            @get('model.broader').then (broaders) =>
              broaders.pushObject(newconcept)
              controller.get('resourcesAfter')?.push(@get('model'))
              controller.set('disableEditingBroader', false)
          when "narrower"
            newconcept.set('broader', [@get('model')])
            @get('model.narrower')?.then (narrowers) =>
              narrowers.pushObject(newconcept)
              controller.get('resourcesAfter')?.push(@get('model'))
            controller.set('disableEditingBroader', true)

    transitionToCreateFromDeprecated: (options) ->
      console.log "transition to create concept to replace deprecated one"
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller

        # setting type
        controller.set 'chosenType', options

        # generating context message
        label = @get('model.loadedDefaultPrefLabel')
        contextMessage = "Creating a new <strong>replacement #{options.label}</strong> for <strong>#{label}</strong>"
        controller.set 'contextMessage', contextMessage

        # making sure we redirect to the old concept
        controller.set('targetScheme', @get('hierarchyService.taxonomy'))
        controller.set('targetConcept', @get('hierarchyService.target'))

        # preparing concept
        newconcept = controller.get('model')


        @get('model.replacements').reload().then (reps) =>
          # Per each replacement concept, add the current one as the one they replace.
          newconcept.get('replaces').then (replaces) =>
            replaces.pushObject @get('model')
            newconcept.save()

          reps.pushObject newconcept


    transitionToCreateEssentialSkills: ->
      console.log "transition to create received - ess. sk"
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller

        # setting type
        controller.set 'chosenType', @get('skillParameters')
        controller.set 'disableSwitchSkillType', true

        # generating context message
        label = @get('model.loadedDefaultPrefLabel')
        contextMessage = "Creating a new <strong>essential skill</strong> concept for <strong>#{label}</strong>"
        controller.set 'contextMessage', contextMessage

        # making sure we redirect to the old concept
        controller.set('targetScheme', @get('hierarchyService.taxonomy'))
        controller.set('targetConcept', @get('hierarchyService.target'))

        # preparing concept
        newconcept = controller.get('model')
        relationshipType = env.relationshipTypes.ESSENTIAL_SKILL_IRI
        relation = @get('store').createRecord('conceptRelation',{
          type: [relationshipType],
          from: @get('model'),
          to: newconcept
        })
        controller.get('resourcesAfter')?.push(relation)
    transitionToCreateOptionalSkills: ->
      console.log "transition to create received - opt. sk"
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller

        # setting type
        controller.set 'chosenType', @get('skillParameters')
        controller.set 'disableSwitchSkillType', true

        # generating context message
        label = @get('model.loadedDefaultPrefLabel')
        contextMessage = "Creating a new <strong>optional skill</strong> concept for <strong>#{label}</strong>"
        controller.set 'contextMessage', contextMessage

        # making sure we redirect to the old concept
        controller.set('targetScheme', @get('hierarchyService.taxonomy'))
        controller.set('targetConcept', @get('hierarchyService.target'))

        # preparing concept
        newconcept = controller.get('model')
        relationshipType = env.relationshipTypes.OPTIONAL_SKILL_IRI
        relation = @get('store').createRecord('conceptRelation',{
          type: [relationshipType],
          from: @get('model'),
          to: newconcept
        })
        controller.get('resourcesAfter')?.push(relation)
    transitionToCreateEssentialKnowledge: ->
      console.log "transition to create received - ess. kno"
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller

        # setting type
        controller.set 'chosenType', @get('knowledgeParameters')
        controller.set 'disableSwitchSkillType', true

        # generating context message
        label = @get('model.loadedDefaultPrefLabel')
        contextMessage = "Creating a new <strong>essential knowledge</strong> concept for <strong>#{label}</strong>"
        controller.set 'contextMessage', contextMessage

        # making sure we redirect to the old concept
        controller.set('targetScheme', @get('hierarchyService.taxonomy'))
        controller.set('targetConcept', @get('hierarchyService.target'))

        # preparing concept
        newconcept = controller.get('model')
        relationshipType = env.relationshipTypes.ESSENTIAL_SKILL_IRI
        relation = @get('store').createRecord('conceptRelation',{
          type: [relationshipType],
          from: @get('model'),
          to: newconcept
        })
        controller.get('resourcesAfter')?.push(relation)
    transitionToCreateOptionalKnowledge: ->
      console.log "transition to create received - opt. kno"
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller

        # setting type
        controller.set 'chosenType', @get('knowledgeParameters')
        controller.set 'disableSwitchSkillType', true

        # generating context message
        label = @get('model.loadedDefaultPrefLabel')
        contextMessage = "Creating a new <strong>optional knowledge concept</strong> for <strong>#{label}</strong>"
        controller.set 'contextMessage', contextMessage

        # making sure we redirect to the old concept
        controller.set('targetScheme', @get('hierarchyService.taxonomy'))
        controller.set('targetConcept', @get('hierarchyService.target'))

        # preparing concept
        newconcept = controller.get('model')
        relationshipType = env.relationshipTypes.OPTIONAL_SKILL_IRI
        relation = @get('store').createRecord('conceptRelation',{
          type: [relationshipType],
          from: @get('model'),
          to: newconcept
        })
        controller.get('resourcesAfter')?.push(relation)
    transitionToCreateInverseRelations: (concepttype, relationtype) ->
      console.log "transition to create received - [#{concepttype}] [#{relationtype}]"
      @transitionToRoute('concepts.create').then (route) =>
        controller = route.controller

        # setting type
        if concepttype is "occupation"
          params =  @get('occupationParameters')
        else if concepttype is "skill"
          controller.set 'disableSwitchSkillType', true
          params =  @get('skillParameters')
        else if concepttype is "knowledge"
          controller.set 'disableSwitchSkillType', true
          params = @get('knowledgeParameters')
        controller.set 'chosenType', params

        # generating context message
        label = @get('model.loadedDefaultPrefLabel')
        contextMessage = "Creating a new <strong>#{concepttype}</strong> concept in a relation with <strong>#{label}</strong>"
        controller.set 'contextMessage', contextMessage

        # making sure we redirect to the old concept
        controller.set('targetScheme', @get('hierarchyService.taxonomy'))
        controller.set('targetConcept', @get('hierarchyService.target'))

        # preparing concept
        newconcept = controller.get('model')
        relationshipType = relationtype
        relation = @get('store').createRecord('conceptRelation',{
          type: [relationshipType],
          from: newconcept,
          to: @get('model')
        })
        controller.get('resourcesAfter')?.push(relation)

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


`export default ConceptsShowController`
