`import { moduleFor, test } from 'ember-qunit'`

moduleFor 'route:menu/diff-publications', 'Unit | Route | menu/diff publications', {
  # Specify the other units that are required for this test.
  # needs: ['controller:foo']
}

test 'it exists', (assert) ->
  route = @subject()
  assert.ok route
