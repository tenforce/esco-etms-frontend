`import Ember from 'ember'`
`import UserRightsMixin from '../../../mixins/user-rights'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | user rights'

# Replace this with your real tests.
test 'it works', (assert) ->
  UserRightsObject = Ember.Object.extend UserRightsMixin
  subject = UserRightsObject.create()
  assert.ok subject
