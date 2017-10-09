`import DS from 'ember-data'`

StringSet = DS.Transform.extend
  deserialize: (serialized) ->
    Ember.assert "expected array got #{Ember.typeOf(serialized)}", (not serialized) or Ember.typeOf(serialized) == "array"
    serialized or []
  serialize: (deserialized) ->
    Ember.assert "expected array got #{Ember.typeOf(deserialized)}", (not deserialized) or Ember.typeOf(deserialized) == "array"
    deserialized or []
`export default StringSet`
