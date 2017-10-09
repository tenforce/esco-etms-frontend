`import statusTransitions from '../../../utils/status-transitions'`
`import { module, test } from 'qunit'`

module 'Unit | Utility | status transitions'

# Replace this with your real tests.
test 'it works', (assert) ->
  result = statusTransitions()
  assert.ok result

test 'it properly filters by concept', (assert) ->
  description = {
    nodes: ['Draft', 'Ready for publication'],
    edges: [
      {
        from: 'Draft',
        to: 'Ready for publication',
        predicates: [(() -> false )],
        predicateCriteria: 'all'
      },
      {
        from: 'Ready for publication',
        to: 'Draft',
        predicates: [],
        predicateCriteria: 'any'
      }
    ]
  }

  result = statusTransitions(description, 'Draft')
