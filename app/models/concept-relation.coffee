`import DS from 'ember-data'`
`import ESCO from 'ember-esco-concept-description'`

ConceptRelation = DS.Model.extend ESCO.Relation,
  readOnlyRelationships: []
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  lastModifier: DS.belongsTo('user', inverse: null, async: false )
  lastModified: DS.attr('string')
  save: () ->
    if not @get('isDeleted')
      @set('lastModifier', @get('user'))
      @set('lastModified', (new Date()).toISOString())
    @_super(arguments...)

`export default ConceptRelation`
