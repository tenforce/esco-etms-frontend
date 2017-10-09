`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'concept-status', 'Integration | Component | concept status', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{concept-status}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#concept-status}}
      template block text
    {{/concept-status}}
  """

  assert.equal @$().text().trim(), 'template block text'
