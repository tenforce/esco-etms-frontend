`import Ember from 'ember'`

# This function receives the params `params, hash`
dialogTargetGenerator = (params) ->
  return '#' + params[0]

DialogTargetGeneratorHelper = Ember.Helper.helper dialogTargetGenerator

`export { dialogTargetGenerator }`

`export default DialogTargetGeneratorHelper`
