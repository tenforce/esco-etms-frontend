`import DS from 'ember-data'`
`import HasManyQuery from 'ember-data-has-many-query'`


Account = DS.Model.extend HasManyQuery.ModelMixin,
  username: DS.attr('string')
  user: DS.belongsTo('user', {inverse: null})
  status: DS.attr()

`export default Account`
