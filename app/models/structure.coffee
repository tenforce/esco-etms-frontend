`import DS from 'ember-data'`
`import ESCO from 'ember-esco-concept-description'`

Structure = DS.Model.extend ESCO.Structure,
  readOnlyAttributes: []

`export default Structure`
