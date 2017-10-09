`import DS from 'ember-data'`
`import HasManyQuery from 'ember-data-has-many-query'`


Bookmark = DS.Model.extend
  bookmarkDate: DS.attr('string')
  bookmarkConcept: DS.belongsTo('concept', inverse: null)


`export default Bookmark`
