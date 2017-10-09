`import DS from 'ember-data'`
`import HasManyQuery from 'ember-data-has-many-query'`

Group = DS.Model.extend
  readOnlyAttributes: ['name']
  readOnlyRelationships: ['members']
  name: DS.attr('string')
  members: DS.hasMany('user', inverse: null)
`export default Group`
