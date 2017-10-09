`import DS from 'ember-data'`
`import HasManyQuery from 'ember-data-has-many-query'`

User = DS.Model.extend
  readOnlyRelationships: ['groups']
  name: DS.attr('string')
  language: DS.attr('string')
  showIscoInChosenLanguage: DS.attr('string', { defaultValue: "no" })
  disableShortcuts: DS.attr('string', { defaultValue: "no"})
  poetryTask: DS.belongsTo('poetry-task', inverse: null)
  groups: DS.hasMany('group', inverse: null)
  bookmarks: DS.hasMany('bookmark', inverse: null)

`export default User`
