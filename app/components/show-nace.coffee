`import Ember from 'ember'`

ShowNaceComponent = Ember.Component.extend

  element: Ember.computed ->
    @getNace()

  getNace: ->
    relatedElement = "concept.nace"
    @get(relatedElement).then (relatedConcept) ->
      promises = []

      relatedConcept.forEach (concept) ->
        promises.push(concept)

      Ember.RSVP.Promise.all(promises).then (labels) ->
        return labels

  addElements: (items) ->
    relatedElement = "concept.nace"
    @get(relatedElement).then (relatedConcept) =>
      items.forEach (item) =>
        relatedConcept.pushObject(item)
      @get('concept').save()
      @set('element', @getNace())

  deleteElement: (item) ->
    relatedElement = "concept.nace"
    @get(relatedElement).then (relatedConcept) =>
      promises = []
      relatedConcept.forEach (concept) ->
        promises.push(concept.get('defaultPrefLabel'))

      Ember.RSVP.Promise.all(promises).then (labels) =>
        item.get('defaultPrefLabel').then (label) =>
          relatedConcept.removeAt(labels.indexOf(label))
          @get('concept').save()
          @set('element', @getNace())

  actions:
    deleteRelation: (item) ->
      @deleteElement(item)
      false

    saveAllElements: (results) ->
      @addElements(results)
      false

`export default ShowNaceComponent`
