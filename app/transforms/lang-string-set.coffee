`import Ember from 'ember'`
`import Transform from 'ember-data/transform'`

LangStringSet = Transform.extend
  # TODO : fix this when mu-cl-resources (or virtuoso?) has been patched
  deserialize: (serialized) ->
    if (serialized && Ember.typeOf(serialized) == 'array')
      arr = serialized.map((o) -> Ember.Object.create(o))
      # the \n we're being send back by mu-cl-resources is not interpreted as a line feed so we have to force it
      arr.forEach (item) ->
        item['content'] = item['content'].split('\\n').join('\n')
      arr
    else
      console.log "lang string set should be an array"
  serialize: (deserialized) ->
    return deserialized

`export default LangStringSet`
