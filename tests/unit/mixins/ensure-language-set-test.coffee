`import Ember from 'ember'`
`import EnsureLanguageSetMixin from '../../../mixins/ensure-language-set'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | ensure language set'

# Replace this with your real tests.
test 'it works', (assert) ->
  EnsureLanguageSetObject = Ember.Object.extend EnsureLanguageSetMixin
  subject = EnsureLanguageSetObject.create()
  assert.ok subject
