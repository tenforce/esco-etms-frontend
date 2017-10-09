`import DS from 'ember-data'`
`import ValidationMixinResult from 'validation-addon/mixins/validation-result'`

ValidationResult = DS.Model.extend ValidationMixinResult,
  parameterDuplicateIn: DS.attr('string-set')

`export default ValidationResult`
