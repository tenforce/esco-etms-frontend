`import Ember from 'ember'`
`import Transform from 'ember-data/transform'`

# TODO : delete me when mu-cl-resources (or virtuoso ?) is patched
StringTransform = Transform.extend
  # the \n sent back by mu-cl-resources is not considered as a line feed, so we have to do this dirty trick to actually handle it
  deserialize: (serialized) ->
    if serialized
      serialized = serialized.split('\\n').join('\n')
    return serialized
  serialize: (deserialized) ->
    return deserialized

`export default StringTransform`
