`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'route:admin/import', 'Unit | Route | admin/import', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route
