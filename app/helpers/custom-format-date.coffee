 `import Ember from 'ember'`

 # This function receives the params `params, hash`
 customFormatDate = (date, options) ->
   return moment(date[0]).format(options.format)

 CustomFormatDateHelper = Ember.Helper.helper customFormatDate

 `export { customFormatDate }`

 `export default CustomFormatDateHelper`
