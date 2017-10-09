`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'route:menu/create-publication', 'Unit | Route | menu/create publication', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route
