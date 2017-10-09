`import DS from 'ember-data'`
`import ESCO from 'ember-esco-concept-description'`

LabelRole = DS.Model.extend ESCO.LabelRole,
  readOnlyAttributes: []

  # overriding as we will modify the displayLabel in show controller and we don't make the original data to be modified
  displayLabel: Ember.computed.oneWay 'preflabel'
`export default LabelRole`
