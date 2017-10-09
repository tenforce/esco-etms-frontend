`import DS from 'ember-data'`
`import ESCO from 'ember-esco-concept-description'`

ConceptScheme = DS.Model.extend ESCO.ConceptScheme,
  children: Ember.computed.alias 'topConcepts'
  members: DS.hasMany('concept', inverse: null)
  readOnlyAttributes: []
  readOnlyRelationships: []

`export default ConceptScheme`
