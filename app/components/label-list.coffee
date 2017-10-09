`import Ember from 'ember'`

LabelListComponent = Ember.Component.extend
  labels: Ember.computed ->
    relatedElement = "concept." + @get 'relation'
    @get(relatedElement)?.then (relatedConcept) ->
      promises = []

      relatedConcept.forEach (concept) ->
        # promises.push(concept.get('defaultPrefLabel'))
        promises.push(concept)

      Ember.RSVP.Promise.all(promises).then (labels) ->
        # return labels.sort()
        return labels

`export default LabelListComponent`
