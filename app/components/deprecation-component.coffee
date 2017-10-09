`import Ember from 'ember'`
`import env from '../config/environment'`

DeprecationComponentComponent = Ember.Component.extend
  tagName: ""
  buttonText: "Add more replacements"
  store: Ember.inject.service()
  showConfirmationPopup: false
  conceptScheme: Ember.computed 'model.isSkill', ->
    console.log 'todo - better way to get conceptSchemeId' # TODO how about a service?
    if @get 'model.isSkill'
      return env.etms.skillScheme
    return env.etms.occupationScheme

  creationConceptOptions: Ember.computed ->
    options = env.creationConceptOptions
    switch
      when @get('model.isOccupation')     then options.occupation
      when @get('model.isSkillKnowledge') then options.knowledge
      when @get('model.isSkillSkill')     then options.skill


  isResetable: false
  isResetableObserver: Ember.observer 'model.hasPublicationStatus', (->
    status = @get('model.hasPublicationStatus')
    promises = [status]
    Ember.RSVP.Promise.all(promises).then (labels) =>
      label = labels.get('firstObject.label')
      if label and (label is 'ready for deprecation')
        @set 'isResetable', true
      else
        @set 'isResetable', false
    ).on('init','model.hasPublicationStatus')


  getReplacements: Ember.observer 'model.replacements', (->
    @get('model.replacements').then (relatedConcepts) =>
      labels = relatedConcepts.map (concept) -> { label: concept.get('defaultPrefLabel'), id: concept.get('id') }
      if labels.length > 0
        @set 'buttonText', "Add more replacements"
      else
        @set 'buttonText', "Replace it"
      @set 'replacements', labels.sort()
    ).on('init')

  addElements: (items) ->
    @get('model.replacements').then (reps) =>
      # Take all the concepts that replace the current one.
      items.forEach (item) =>
        # Per each replacement concept, add the current one as the one they replace.
        item.get('replaces').then (replaces) =>
          replaces.forEach (repl) =>
            replaces.pushObject(@get('model'))
          item.save()
        reps.pushObject(item)
      @get('model').save().then (savedM) =>
        @set 'buttonText', "Add more replacements"

  deleteElement: (item) ->
    @get('model.replacements').then (replacements) =>
      replacements.forEach (concept, index) =>
        concept.get('defaultPrefLabel').then (label) =>
          if label == item
            replacements.removeAt index
            @get('model').save().then =>
              if replacements.length == 0
                @set 'buttonText', "Replace it"

  undoDeprecation: ->
    console.log 'TODO: reset to previous published version'
    @get('model.replacements').then (relatedConcept) =>
      relatedConcept.clear()
      publications = @get('store').query('publicationStatus', {filter: {'label': 'published'}})
      promises = [publications]

      Ember.RSVP.Promise.all(promises).then (statuses) =>
        statuses.get('firstObject').forEach (status) =>
          label = status.get('label')
          if label == 'published'
            @set 'model.hasPublicationStatus', status
            @get('model').save()

  actions:
    closeConfirmation: ->
      @set 'showConfirmationPopup', false
      false
    deleteRelation: (item) ->
      @deleteElement(item)
      false
    undoDeprecation: ->
      @undoDeprecation()
      false
    confirmUndoDeprecation: ->
      @set 'showConfirmationPopup', true
      false
    saveAllElements: (results) ->
      @addElements(results)
      false
    transitionToCreate: ->
      @sendAction 'transitionToCreateFromDeprecated', @get('creationConceptOptions')

`export default DeprecationComponentComponent`
