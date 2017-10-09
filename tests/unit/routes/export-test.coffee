`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'route:export', 'Unit | Route | export', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route
