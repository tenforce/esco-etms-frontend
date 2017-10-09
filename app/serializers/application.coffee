`import DS from 'ember-data'`

JSONAPISerializer = DS.JSONAPISerializer.extend
  # for every model that we serialize, we check if they have readOnly properties and if so, we remove them from the request sent to the backend
  # in order to lighten the load
  serialize: (snapshot, options) ->
    json = @_super(arguments...)
    readOnlyAttributes = snapshot.record.get('readOnlyAttributes')
    readOnlyAttributes?.forEach (attribute) ->
      delete json?.data?.attributes?[attribute]
    readOnlyRelationships = snapshot.record.get('readOnlyRelationships')
    readOnlyRelationships?.forEach (relation) ->
      delete json?.data?.relationships?[relation]
    json
`export default JSONAPISerializer`
