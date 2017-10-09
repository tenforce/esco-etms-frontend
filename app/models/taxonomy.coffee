`import DS from 'ember-data'`
`import ESCO from 'ember-esco-concept-description'`

Taxonomy = DS.Model.extend ESCO.Pillar,
  children: Ember.computed.alias 'topConcepts'
  readOnlyAttributes: []
  readOnlyRelationships: []

`export default Taxonomy`
